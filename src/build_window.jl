struct ColumnSelector
    toggle::GtkToggleButton
    buttons::Vector{GtkCheckButton}
end

ColumnSelector(colname::AbstractString, colvalues::AbstractVector{T}) where T<:AbstractString =
ColumnSelector(GtkToggleButton(colname), GtkCheckButton.(sort(collect(colvalues))))

#column_selectors = ColumnSelector.(["a", "b"], [["w", "ww"], ["a"]])

function build_window(column_selectors::AbstractVector{ColumnSelector})
    win = GtkWindow("A new window")
    g = GtkGrid()
    for (i, column_selector) in enumerate(column_selectors)
        g[i,1] = column_selector.toggle
        for (j, button) in enumerate(column_selector.buttons)
            g[i,j+1] = button
        end
    end
    setproperty!(g, :column_homogeneous, true)
    setproperty!(g, :column_spacing, 15)  # introduce a 15-pixel gap between columns
    push!(win, g)
    showall(win)
    return column_selectors
end
