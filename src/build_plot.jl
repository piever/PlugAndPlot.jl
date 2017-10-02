const plot_functions = Dict(
    :plot => [plot, (args...; kwargs...) -> plot!(shared.plt, args...; kwargs...)],
    :scatter => [scatter, (args...; kwargs...) -> scatter!(shared.plt, args...; kwargs...)],
    :groupedbar => [groupedbar, (args...; kwargs...) -> groupedbar!(shared.plt, args...; kwargs...)],
    :boxplot => [boxplot, (args...; kwargs...) -> boxplot!(shared.plt, args...; kwargs...)],
    :violin => [violin, (args...; kwargs...) -> violin!(shared.plt, args...; kwargs...)],
    :marginalhist => [marginalhist, marginalhist]
)


function get_plotvalues(df)
    xvalues = ComboBoxType("X AXIS", ComboBoxEntry.(string.(names(df))), true)
    ylist = string.(union([:hazard, :density, :cumulative],names(df)))
    yvalues = ComboBoxType("Y AXIS", ComboBoxEntry.(ylist), true)
    plotlist = [
        "plot",
        "scatter",
        "groupedbar",
        "boxplot",
        "violin",
        "marginalhist"
    ]
    plot_type = ComboBoxType("PLOT TYPE", ComboBoxEntry.(plotlist), false)
    axislist = ["pointbypoint", "continuous", "binned", "discrete"]
    axis_type = ComboBoxType("AXIS TYPE", ComboBoxEntry.(axislist) , false)
    errorlist = union(["none", "bootstrap", "across"], "across " .* string.(names(df)))
    compute_error = ComboBoxType("COMPUTE ERROR",  ComboBoxEntry.(errorlist), false)
    namelist = union(["pointbypoint"], "point=" .* string.(names(df)))
    dataperpoint = ComboBoxType("DATA PER POINT",  ComboBoxEntry.(namelist), false)
    return [xvalues, yvalues, plot_type, axis_type, compute_error, dataperpoint]
end

get_kwargs(s) = s == "" ? [] : [(x.args[1], eval(x.args[2])) for x in parse("("*s*",)").args]

get_func(s) = (s == "") ? mean : eval(parse(s))

function get_plot!(shared, in_place)
    df, selectlist, plotvalues = shared.df, shared.selectlist, shared.plotvalues
    selectdata = choose_data(shared)
    xval, yval, line, axis_type, compute_error, dataperpoint =
        getfield.(plotvalues, :chosen_value)
    extra_kwargs = get_kwargs(shared.plotkwargs.value)
    x_info, y_info = plotvalues[1].text_info, plotvalues[2].text_info
    xfunc = get_func(x_info)
    yfunc = get_func(y_info)
    isrecipe = !(Symbol(line) in [:plot, :scatter, :groupedbar])
    isgroupapply = !isrecipe && !(Symbol(axis_type) == :pointbypoint)
    xlabel, ylabel = xval, yval
    plot_func = (args...; kwargs...) -> plot_functions[Symbol(line)][in_place ? 2 : 1](args...;
                xlabel = xlabel, ylabel = ylabel, kwargs..., extra_kwargs...)
    group_cols = [Symbol(col.name) for col in selectlist if col.split]

    maybe_nbins = Symbol(axis_type) == :binned ? (round(Int64, 101-shared.smoother.value),) : ()

    s = GroupedErrors.ColumnSelector(selectdata)
    s = GroupedErrors._splitby(s, group_cols)
    if (Symbol(axis_type) == :pointbypoint) || isrecipe
        if !isrecipe && ('=' in dataperpoint)
            s = GroupedErrors._across(s, Symbol(split(dataperpoint, '=')[2]))
            if check_equality() && (':' in shared.splitting_var.chosen_value)
                splitting_var = Symbol(split(shared.splitting_var.chosen_value, ':')[2])
                s = GroupedErrors._compare(s, splitting_var)
            end
        end
        if isrecipe
            s = GroupedErrors._x(s, Symbol(xval))
            s = GroupedErrors._y(s, Symbol(yval))
        else
            s = GroupedErrors._x(s, Symbol(xval), xfunc)
            s = GroupedErrors._y(s, Symbol(yval), yfunc)
        end
    else
        compute_error = convert_error_type(compute_error)
        if compute_error[1] == :across
            s = GroupedErrors._across(s, compute_error[2])
        elseif compute_error[1] == :bootstrap
            s = GroupedErrors._bootstrap(s, compute_error[2])
        end
        s = GroupedErrors._x(s, Symbol(xval), Symbol(axis_type), maybe_nbins...)
        if Symbol(axis_type) == :continuous
            if haskey(selectdata, Symbol(yval))
                s = GroupedErrors._y(s, :locreg, Symbol(yval), span = (shared.smoother.value+1.0)/100)
            elseif Symbol(yval) in [:density, :hazard]
                s = GroupedErrors._y(s, Symbol(yval), bandwidth = (shared.smoother.value+1.0)*std(selectdata[Symbol(xval)])/200)
            else
                s = GroupedErrors._y(s, Symbol(yval))
            end
        else
            s = GroupedErrors._x(s, Symbol(xval), xfunc)
            if haskey(selectdata, Symbol(yval))
                s = GroupedErrors._y(s, :locreg, Symbol(yval), estimator = yfunc)
            else
                s = GroupedErrors._y(s, Symbol(yval))
            end
        end
    end
    shared.plt = Symbol(line) == :plot ? @plot(s, plot_func(), :ribbon) : @plot(s, plot_func())
    get(s.kw, :compare, false) && Plots.abline!(shared.plt, 1, 0, legend = false)
end


function convert_error_type(s::AbstractString)
    n = search(s, ' ')
    if n == 0
        if Symbol(s) == :bootstrap
            return (:bootstrap, 1000)
        elseif Symbol(s) == :across
            return (:across, :all)
        else
            return (Symbol(s),)
        end
    else
        return (Symbol(s[1:n-1]), Symbol(s[n+1:end]))
    end
end
