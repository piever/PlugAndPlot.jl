function get_plotvalues(df)
    xvalues = ComboBoxType("X AXIS", ComboBoxEntry.(string.(names(df))))
    ylist = union([:hazard, :density, :cumulative],names(df))
    yvalues = ComboBoxType("Y AXIS", ComboBoxEntry.(string.(ylist)))
    plot_type = ComboBoxType("PLOT TYPE",  ComboBoxEntry.(["bar", "path", "scatter"]))
    axis_type = ComboBoxType("AXIS TYPE",  ComboBoxEntry.(["auto", "discrete", "continuous"]))
    errorlist = union([:none], "across " .* string.(names(df)))
    compute_error = ComboBoxType("COMPUTE ERROR",  ComboBoxEntry.(errorlist))
    return [xvalues, yvalues, plot_type, axis_type, compute_error]
end



function get_plot(df, selectlist, plotvalues)
    selectdata = choose_data(df, selectlist)
    xval, yval, line, axis_type, compute_error = getfield.(plotvalues, :chosen_value)
    group_vars = [Symbol(col.name) for col in selectlist if col.split]
    grp_error = groupapply(Symbol(yval),
        selectdata,
        Symbol(xval),
        group = group_vars,
        compute_error = convert_error_type(compute_error),
        axis_type = Symbol(axis_type))
    plot(grp_error, line = Symbol(line),
        xlabel = xval, ylabel = yval)
end


function convert_error_type(s::AbstractString)
    n = search(s, ' ')
    if n == 0
        return Symbol(s)
    else
        return (Symbol(s[1:n-1]), Symbol(s[n+1:end]))
    end
end
