function get_plot(df, selectlist, plotvalues)
    selectdata = choose_data(df, selectlist)
    xval = plotvalues[1].chosen_value
    yval = plotvalues[2].chosen_value
    group_vars = [Symbol(col.name) for col in selectlist if col.split]
    grp_error = groupapply(Symbol(yval),
    selectdata,
    Symbol(xval),
    group = group_vars)
    plot(grp_error, line = Symbol(plotvalues[3].chosen_value),
    xlabel = xval, ylabel = yval)
end
