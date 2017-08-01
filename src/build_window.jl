mutable struct Shared
    df::DataFrame
    selectlist::Vector{Column}
    plotvalues::Vector{ComboBoxType}
end
shared = Shared(DataFrame(),Column[], ComboBoxType[])

function build_window(; kwargs...)
    @qmlapp joinpath(Pkg.dir("ManipulateTable","src"), "QML", "choose_file.qml")
    path = Path("")
    @qmlset qmlcontext().choose = path
    exec()
    return build_window(path.file; kwargs...)
end

function build_window(datafile; nbox = 5)
    #shared.df = DataFrame(FileIO.load(datafile))#DataFrame(FileIO.load(datafile))
    cols, name_cols = csvread(String(datafile); header_exists = true)
    shared.df = DataFrame(collect(cols), Symbol.(name_cols))
    shared.selectlist = [Column(string(name), string.(union(shared.df[name])))
        for name in names(shared.df) if (1 < length(union(shared.df[name])) < nbox)]

    # run QML window
    qml_engine = init_qmlapplicationengine()
    @qmlset qmlcontext()._selectlist = ListModel(shared.selectlist)
    shared.plotvalues = get_plotvalues(shared.df)
    @qmlset qmlcontext()._plotvalues = ListModel(shared.plotvalues)

    #@qmlfunction plotsin
    @qmlfunction my_function
    qml_file = joinpath(Pkg.dir("ManipulateTable","src"), "QML", "gui.qml")
    QML.load(qml_engine,qml_file)

    exec()
    return
end


function my_function(d::JuliaDisplay, width, height)
    gr(grid = false, size=(Int64(round(width)),Int64(round(height))))
    plt = get_plot(shared.df, shared.selectlist, shared.plotvalues)
    display(d, plt)
    return
end
