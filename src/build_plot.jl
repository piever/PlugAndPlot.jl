function get_plot(df, selectlist, plotvalues)
    selectdata = choose_data(df, selectlist)
    group_vars = [Symbol(col.name) for col in selectlist if col.split]
    grp_error = groupapply(Symbol(plotvalues[2].chosen_value),
    selectdata,
    Symbol(plotvalues[1].chosen_value),
    group = group_vars)
    plot(grp_error, line = Symbol(plotvalues[3].chosen_value))
end
