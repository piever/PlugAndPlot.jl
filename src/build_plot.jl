function get_plotvalues(df)
    xvalues = ComboBoxType("X AXIS", ComboBoxEntry.(string.(names(df))), true)
    ylist = union([:hazard, :density, :cumulative],names(df))
    yvalues = ComboBoxType("Y AXIS", ComboBoxEntry.(string.(ylist)), true)
    plot_type = ComboBoxType("PLOT TYPE",  ComboBoxEntry.(["bar", "path", "scatter"]), false)
    axis_type = ComboBoxType("AXIS TYPE",  ComboBoxEntry.(["continuous", "discrete"]), false)
    errorlist = union([:none], "across " .* string.(names(df)))
    compute_error = ComboBoxType("COMPUTE ERROR",  ComboBoxEntry.(errorlist), false)
    analysis_type = ComboBoxType("ANALYSIS TYPE",  ComboBoxEntry.(["Population", "Individual"]), false)
    return [xvalues, yvalues, plot_type, axis_type, compute_error, analysis_type]
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

function get_plot(shared)
    df, selectlist, plotvalues = shared.df, shared.selectlist, shared.plotvalues
    selectdata = choose_data(shared)
    xval, yval, line, axis_type, compute_error, analysis_type = getfield.(plotvalues, :chosen_value)
    group_vars = [Symbol(col.name) for col in selectlist if col.split]
    extra_kwargs = get_kwargs(shared.plotkwargs.value)
    x_info, y_info = plotvalues[1].text_info, plotvalues[2].text_info
    xfunc = get_func(x_info, Symbol(xval))
    yfunc = get_func(y_info, Symbol(yval))

    if analysis_type == "Population"
        smooth_kwargs = []
        if Symbol(axis_type) == :continuous
            if Symbol(yval) == :density
                bandwidth = shared.smoother.value*std(selectdata[Symbol(xval)])/100
                smooth_kwargs = [(:bandwidth, bandwidth)]
            end
        end
        grp_error = groupapply(Symbol(yval),
            selectdata,
            Symbol(xval);
            group = group_vars,
            compute_error = convert_error_type(compute_error),
            axis_type = Symbol(axis_type),
            smooth_kwargs...)
        plt = plot(grp_error; line = Symbol(line),
            xlabel = xval, ylabel = yval, extra_kwargs...)
    else
        summary_df = by(selectdata, vcat(group_vars, convert_error_type(compute_error)[2])) do dd_subject
            DataFrame(x = xfunc(dd_subject), y = yfunc(dd_subject))
        end
        group_col = [string(["$(summary_df[i,grp]) " for grp in group_vars]...) for i in 1:size(summary_df,1)]
        plt = scatter(summary_df, :x, :y; group = group_col, extra_kwargs...)
    end
    return plt
end


function convert_error_type(s::AbstractString)
    n = search(s, ' ')
    if n == 0
        return Symbol(s)
    else
        return (Symbol(s[1:n-1]), Symbol(s[n+1:end]))
    end
end
