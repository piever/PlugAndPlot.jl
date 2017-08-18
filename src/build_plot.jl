function get_plotvalues(df)
    xvalues = ComboBoxType("X AXIS", ComboBoxEntry.(string.(names(df))), true)
    ylist = string.(union([:hazard, :density, :cumulative],names(df)))
    yvalues = ComboBoxType("Y AXIS", ComboBoxEntry.(ylist), true)
    plotlist = [
        "bar",
        "path",
        "line",
        "scatter",
        "boxplot",
        "violin",
        "marginalhist"
    ]
    plot_type = ComboBoxType("PLOT TYPE", ComboBoxEntry.(plotlist), false)
    axislist = ["continuous", "binned", "discrete", "pointbypoint"]
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
    group_vars = [Symbol(col.name) for col in selectlist if col.split]
    extra_kwargs = get_kwargs(shared.plotkwargs.value)
    x_info, y_info = plotvalues[1].text_info, plotvalues[2].text_info
    xfunc = get_func(x_info)
    yfunc = get_func(y_info)
    isrecipe = !(Symbol(line) in [:bar, :path, :scatter, :line])
    isgroupapply = !isrecipe && !(Symbol(axis_type) == :pointbypoint)
    xlabel, ylabel = xval, yval
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
        elseif (Symbol(axis_type) == :discrete) && haskey(selectdata, Symbol(yval))
            smooth_kwargs = [(:estimator, yfunc)]
        end

        grp_error = groupapply(Symbol(yval),
            selectdata,
            Symbol(xval);
            group = group_vars,
            compute_error = convert_error_type(compute_error),
            axis_type = Symbol(axis_type),
            smooth_kwargs...)
        linestyle = (line == "line") ? :path : Symbol(line)
        if in_place
            plot!(shared.plt, grp_error; line = linestyle,
                xlabel = xval, ylabel = yval, extra_kwargs...)
        else
            shared.plt = plot(grp_error; line = linestyle,
                xlabel = xval, ylabel = yval, extra_kwargs...)
        end
    else
        x_name = StatPlots.new_symbol(:x, selectdata)
        y_name = StatPlots.new_symbol(:y, selectdata)
        plot_diag = false
        if isrecipe || !('=' in dataperpoint)
            summary_df = copy(selectdata)
            summary_df[x_name] = summary_df[Symbol(xval)]
            summary_df[y_name] = summary_df[Symbol(yval)]
        else
            datalabel = Symbol(split(dataperpoint, '=')[2])
            if check_equality() && (':' in shared.splitting_var.chosen_value)
                plot_diag = true
                splitting_var = Symbol(split(shared.splitting_var.chosen_value, ':')[2])
                x_val, y_val = sort(union(selectdata[splitting_var]))
                summary_df = by(selectdata, vcat(group_vars, datalabel)) do dd_subject
                    splitter = (dd_subject[splitting_var] .== x_val)
                    DataFrame(;[(x_name, xfunc(dd_subject[splitter, Symbol(xval)])),
                        (y_name, yfunc(dd_subject[.!splitter, Symbol(yval)]))]...)
                end
                xlabel = string("$xval with $splitting_var = $x_val")
                ylabel = string("$yval with $splitting_var = $y_val")
            else
                summary_df = by(selectdata, vcat(group_vars, datalabel)) do dd_subject
                    DataFrame(;[(x_name, xfunc(dd_subject[Symbol(xval)])),
                        (y_name, yfunc(dd_subject[Symbol(yval)]))]...)
                end
            end
        end
        group_col = [string(["$(summary_df[i,grp]) " for grp in group_vars]...)
            for i in 1:size(summary_df,1)]
        if in_place
            plot!(shared.plt, summary_df, x_name, y_name; group = group_col,
                seriestype = Symbol(line), xlabel = xlabel, ylabel = ylabel, extra_kwargs...)
        else
            shared.plt = plot(summary_df, x_name, y_name; group = group_col,
                seriestype = Symbol(line), xlabel = xlabel, ylabel = ylabel, extra_kwargs...)
        end
        plot_diag && Plots.abline!(shared.plt, 1, 0, label = "identity", legend = :topleft)
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
