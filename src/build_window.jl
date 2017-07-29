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
    return build_window(clean(path); kwargs...)
end

function build_window(datafile; nbox = 5)
    shared.df = readtable(datafile)#DataFrame(FileIO.load(datafile))
    shared.selectlist = [Column(string(name), string.(union(shared.df[name])))
        for name in names(shared.df) if length(union(shared.df[name])) < nbox]

    # run QML window
    qml_engine = init_qmlapplicationengine()
    @qmlset qmlcontext()._selectlist = ListModel(shared.selectlist)
    shared.plotvalues = get_plotvalues(shared.df)
    @qmlset qmlcontext()._plotvalues = ListModel(shared.plotvalues)

    #@qmlfunction plotsin
    @qmlfunction my_function
    qml_file = joinpath(Pkg.dir("ManipulateTable","src"), "QML", "gui.qml")
    load(qml_engine,qml_file)

    exec()
    return shared
end


function my_function(d::JuliaDisplay, width, height)
    gr(grid = false, size=(Int64(round(width)),Int64(round(height))))
    plt = get_plot(shared.df, shared.selectlist, shared.plotvalues)
    display(d, plt)
    return
end

function get_plotvalues(df)
    xvalues = ComboBoxType("X AXIS", ComboBoxEntry.(string.(names(df))))
    ylist = union(names(df),[:hazard, :locreg, :density, :cumulative])
    yvalues = ComboBoxType("Y AXIS", ComboBoxEntry.(string.(ylist)))
    plottype = ComboBoxType("PLOT TYPE",  ComboBoxEntry.(["bar", "path", "scatter"]))
    return [xvalues, yvalues, plottype]
end
