struct ColumnSelector
    toggle::GtkToggleButton
    buttons::Vector{GtkCheckButton}
end

ColumnSelector(colname::AbstractString, colvalues::AbstractVector{T}) where T<:AbstractString =
ColumnSelector(GtkToggleButton(colname), GtkCheckButton.(sort(collect(colvalues))))

function create_combobox(labels)
    box = GtkComboBoxText()
    for label in labels
        push!(box,label)
    end
    return box
end

#column_selectors = ColumnSelector.(["a", "b"], [["w", "ww"], ["a"]])

function build_window(xlabels, ylabels, column_selectors::AbstractVector{ColumnSelector})
    win = GtkWindow("A new window")
    g = GtkGrid()
    xbox = create_combobox(xlabels)
    ybox = create_combobox(ylabels)
    g[1,1] = GtkLabel("x axis")
    g[1,2] = GtkLabel("y axis")
    g[2,1] = xbox
    g[2,2] = ybox
    for (i, column_selector) in enumerate(column_selectors)
        g[i,3] = column_selector.toggle
        for (j, button) in enumerate(column_selector.buttons)
            g[i,j+4] = button
        end
    end
    setproperty!(g, :column_homogeneous, true)
    setproperty!(g, :column_spacing, 15)  # introduce a 15-pixel gap between columns
    setproperty!(g, :row_spacing, 15)
    push!(win, g)
    showall(win)
    return column_selectors
end


# file = GtkMenuItem("_File")
# filemenu = GtkMenu(file)
# new_ = GtkMenuItem("New")
# push!(filemenu, new_)
# open_ = GtkMenuItem("Open")
# push!(filemenu, open_)
# push!(filemenu, GtkSeparatorMenuItem())
# quit = GtkMenuItem("Quit")
# push!(filemenu, quit)
# mb = GtkMenuBar()
# push!(mb, file)  # notice this is the "File" item, not filemenu
# win = GtkWindow(mb, "Menus", 200, 40)
# showall(mb)
