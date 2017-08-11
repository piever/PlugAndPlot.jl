function get_plotvalues(df)
    xvalues = ComboBoxType("X AXIS", ComboBoxEntry.(string.(names(df))), true)
    ylist = union([:hazard, :density, :cumulative],names(df))
    yvalues = ComboBoxType("Y AXIS", ComboBoxEntry.(string.(ylist)), true)
    plot_type = ComboBoxType("PLOT TYPE",  ComboBoxEntry.(["bar", "path", "scatter"]), false)
    axis_type = ComboBoxType("AXIS TYPE",  ComboBoxEntry.(["auto", "discrete", "continuous"]), false)
    errorlist = union([:none], "across " .* string.(names(df)))
    compute_error = ComboBoxType("COMPUTE ERROR",  ComboBoxEntry.(errorlist), false)
    analysis_type = ComboBoxType("ANALYSIS TYPE",  ComboBoxEntry.(["Population", "Individual"]), false)
    return [xvalues, yvalues, plot_type, axis_type, compute_error, analysis_type]
end

get_kwargs(s) = s == "" ? [] : [(x.args[1], eval(x.args[2])) for x in parse("("*s*",)").args]

function get_plot(shared)
    df, selectlist, plotvalues = shared.df, shared.selectlist, shared.plotvalues
    selectdata = choose_data(shared)
    xval, yval, line, axis_type, compute_error, analysis_type = getfield.(plotvalues, :chosen_value)
    group_vars = [Symbol(col.name) for col in selectlist if col.split]
    extra_kwargs = get_kwargs(shared.plotkwargs.value)
    plt = plot()
    x_info, y_info = plotvalues[1].text_info, plotvalues[2].text_info
    xfunc = x_info == "" ? mean : eval(parse(x_info))
    yfunc = y_info == "" ? mean : eval(parse(y_info))
    if analysis_type == "Population"
        grp_error = groupapply(Symbol(yval),
            selectdata,
            Symbol(xval),
            group = group_vars,
            compute_error = convert_error_type(compute_error),
            axis_type = Symbol(axis_type))
        plt = plot(grp_error; line = Symbol(line),
            xlabel = xval, ylabel = yval, extra_kwargs...)
    else
        if length(group_vars) == 0
            summary_df = by(selectdata, convert_error_type(compute_error)[2]) do dd_subject
                DataFrame(x = xfunc(dd_subject[Symbol(xval)]), y = yfunc(dd_subject[Symbol(yval)]))
            end
            scatter!(plt, summary_df, :x, :y; label = "", extra_kwargs...)
        else
            by(selectdata, group_vars) do dd
                summary_df = by(dd, convert_error_type(compute_error)[2]) do dd_subject
                    DataFrame(x = xfunc(dd_subject[Symbol(xval)]), y = yfunc(dd_subject[Symbol(yval)]))
                end
                scatter!(plt, summary_df, :x, :y;
                label = string(["$(dd[1,grp]) " for grp in group_vars]...), extra_kwargs...)
                return
            end
        end
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
