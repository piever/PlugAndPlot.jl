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
    qml_file = joinpath(Pkg.dir("ManipulateTable","src"), "QML", "gui.qml")
    set_source(qview, qml_file)
    QML.show(qview)

    exec()
    selectdata = choose_data(df, selectlist)
    return selectdata, selectlist
end
