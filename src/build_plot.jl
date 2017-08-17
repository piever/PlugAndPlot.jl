function get_plotvalues(df)
    xvalues = ComboBoxType("X AXIS", ComboBoxEntry.(string.(names(df))), true)
    ylist = string.(union([:hazard, :density, :cumulative],names(df)))
    yvalues = ComboBoxType("Y AXIS", ComboBoxEntry.(ylist), true)
    plotlist = [
        "bar",
        "path",
        "scatter",
        "boxplot",
        "violin",
        "marginalhist"
    ]
    plot_type = ComboBoxType("PLOT TYPE", ComboBoxEntry.(plotlist), false)
    axislist = ["continuous", "binned", "discrete", "individual"]
    axis_type = ComboBoxType("AXIS TYPE", ComboBoxEntry.(axislist) , false)
    errorlist = union([:none], "across " .* string.(names(df)))
    compute_error = ComboBoxType("COMPUTE ERROR",  ComboBoxEntry.(errorlist), false)
    return [xvalues, yvalues, plot_type, axis_type, compute_error]
end

get_kwargs(s) = s == "" ? [] : [(x.args[1], eval(x.args[2])) for x in parse("("*s*",)").args]

function get_func(s, x)
    if s == ""
        return df -> mean(df[x])
    else
        expr = parse("("*s*",)")
        func = eval(expr.args[1])
        if length(expr.args) == 1
            return df -> func(df[x])
        else
            sel_var = eval(expr.args[2])
            sel_value = eval(expr.args[3])
            return df -> func(df[df[sel_var] .== sel_value, x])
        end
    end
end

function get_plot!(shared, in_place)
    df, selectlist, plotvalues = shared.df, shared.selectlist, shared.plotvalues
    selectdata = choose_data(shared)
    xval, yval, line, axis_type, compute_error = getfield.(plotvalues, :chosen_value)
    group_vars = [Symbol(col.name) for col in selectlist if col.split]
    extra_kwargs = get_kwargs(shared.plotkwargs.value)
    x_info, y_info = plotvalues[1].text_info, plotvalues[2].text_info
    xfunc = get_func(x_info, Symbol(xval))
    yfunc = get_func(y_info, Symbol(yval))
    isgroupapply = (Symbol(line) in [:bar, :path, :scatter]) &&
        !(Symbol(axis_type) == :individual)

    if isgroupapply
        smooth_kwargs = []
        if Symbol(axis_type) == :continuous
            if Symbol(yval) in [:density, :hazard]
                bandwidth = (shared.smoother.value+1.0)*std(selectdata[Symbol(xval)])/200
                smooth_kwargs = [(:bandwidth, bandwidth)]
            end
            if haskey(selectdata, Symbol(yval))
                span = (shared.smoother.value+1.0)/100
                smooth_kwargs = [(:span, span)]
            end
        elseif Symbol(axis_type) == :binned
            nbins = round(Int64, 101-shared.smoother.value)
            smooth_kwargs = [(:nbins, nbins)]
        end
        grp_error = groupapply(Symbol(yval),
            selectdata,
            Symbol(xval);
            group = group_vars,
            compute_error = convert_error_type(compute_error),
            axis_type = Symbol(axis_type),
            smooth_kwargs...)
        if in_place
            plot!(shared.plt, grp_error; line = Symbol(line),
                xlabel = xval, ylabel = yval, extra_kwargs...)
        else
            shared.plt = plot(grp_error; line = Symbol(line),
                xlabel = xval, ylabel = yval, extra_kwargs...)
        end
    else
        x_name = StatPlots.new_symbol(:x, selectdata)
        y_name = StatPlots.new_symbol(:y, selectdata)
        error_type = convert_error_type(compute_error)
        if typeof(error_type) <: Tuple
            summary_df = by(selectdata, vcat(group_vars, error_type[2])) do dd_subject
                DataFrame(;[(x_name, xfunc(dd_subject)), (y_name, yfunc(dd_subject))]...)
            end
        else
            summary_df = copy(selectdata)
            rename!(summary_df, [Symbol(xval), Symbol(yval)], [x_name, y_name])
        end
        group_col = [string(["$(summary_df[i,grp]) " for grp in group_vars]...)
            for i in 1:size(summary_df,1)]
        if in_place
            plot!(shared.plt, summary_df, x_name, y_name; group = group_col,
                seriestype = Symbol(line), xlabel = xval, ylabel = yval, extra_kwargs...)
        else
            shared.plt = plot(summary_df, x_name, y_name; group = group_col,
                seriestype = Symbol(line), xlabel = xval, ylabel = yval, extra_kwargs...)
        end
    end
end


function convert_error_type(s::AbstractString)
    n = search(s, ' ')
    if n == 0
        return Symbol(s)
    else
        return (Symbol(s[1:n-1]), Symbol(s[n+1:end]))
    end
end
