function build_window(datafile)
    df = readtable(datafile)#DataFrame(FileIO.load(datafile))
    selectlist = [DataColumn(string(name), string.(union(df[name])))
        for name in names(df) if length(union(df[name])) < 5]

    # run QML window
    qview = init_qquickview()
    @qmlset qmlcontext().selectModel = ListModel(selectlist)
    qml_file = joinpath(Pkg.dir("ManipulateTable","src"), "QML", "gui.qml")
    set_source(qview, qml_file)
    QML.show(qview)

    exec()
    return selectdata = choose_data(df, selectlist)
end
