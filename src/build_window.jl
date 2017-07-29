function build_window(; kwargs...)
    @qmlapp joinpath(Pkg.dir("ManipulateTable","src"), "QML", "choose_file.qml")
    path = Path("")
    @qmlset qmlcontext().choose = path
    exec()
    return build_window(clean(path); kwargs...)
end

function build_window(datafile; nbox = 5)
    df = readtable(datafile)#DataFrame(FileIO.load(datafile))
    selectlist = [Column(string(name), string.(union(df[name])))
        for name in names(df) if length(union(df[name])) < nbox]

    # run QML window
    qview = init_qquickview()
    @qmlset qmlcontext()._selectlist = ListModel(selectlist)
    plotvalues = get_plotvalues(df)
    @qmlset qmlcontext()._plotvalues = ListModel(plotvalues)
    qml_file = joinpath(Pkg.dir("ManipulateTable","src"), "QML", "gui.qml")
    set_source(qview, qml_file)
    QML.show(qview)

    exec()
    return df, selectlist,plotvalues
end

function get_plotvalues(df)
    xvalues = ComboBoxType("X AXIS", ComboBoxEntry.(string.(names(df))))
    ylist = union(names(df),[:hazard, :locreg, :density, :cumulative])
    yvalues = ComboBoxType("Y AXIS", ComboBoxEntry.(string.(ylist)))
    plottype = ComboBoxType("PLOT TYPE",  ComboBoxEntry.(["bar", "path", "scatter"]))
    return [xvalues, yvalues, plottype]
end
