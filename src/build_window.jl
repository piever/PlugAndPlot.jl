mutable struct Shared
    df::DataFrame
    selectvalues::Vector{SpinBoxType}
    selectlist::Vector{Column}
    plotvalues::Vector{ComboBoxType}
    plotkwargs::TextBoxEntry
end
shared = Shared(DataFrame(), SpinBoxType[], Column[], ComboBoxType[], TextBoxEntry(""))

"""
    build_window(; kwargs...)

Starts the GUI asking for a suitable csv file.
"""
function build_window(; kwargs...)
    @qmlapp joinpath(Pkg.dir("PlugAndPlot","src"), "QML", "choose_file.qml")
    path = TextBoxEntry("")
    @qmlset qmlcontext().choose = path
    exec()
    return build_window(path.value; kwargs...)
end

"""
    build_window(datafile::AbstractString; kwargs...)

Reads a csv file and starts build_window on the corresponding DataFrame
"""
build_window(datafile::AbstractString; kwargs...) = build_window(readtable(datafile); kwargs...)

"""
    build_window(dataset::AbstractDataFrame; nbox = 5)

Creates a GUI to analyze a DataFrame interactively. Data can be selected either
on continuous columns, with SpinBoxes or on discrete columns with checkboxes,
provided there are less than `nbox` entries.
"""
function build_window(dataset::AbstractDataFrame; nbox = 5)
    shared.df = dataset
    shared.selectlist = [Column(string(name), string.(union(shared.df[name])))
        for name in names(shared.df) if (1 < length(union(shared.df[name])) < nbox)]

    shared.selectvalues = [SpinBoxType(string(name), Float64.([extrema(shared.df[name])...]))
        for name in names(shared.df) if length(union(shared.df[name])) >= nbox &&
        eltype(shared.df[name]) <: Real]
    # run QML window
    qml_engine = init_qmlapplicationengine()
    @qmlset qmlcontext()._selectlist = ListModel(shared.selectlist)
    @qmlset qmlcontext()._selectvalues = ListModel(shared.selectvalues)
    shared.plotvalues = get_plotvalues(shared.df)
    @qmlset qmlcontext()._plotvalues = ListModel(shared.plotvalues)
    @qmlset qmlcontext().choose = shared.plotkwargs
    #@qmlfunction plotsin
    @qmlfunction my_function
    qml_file = joinpath(Pkg.dir("PlugAndPlot","src"), "QML", "gui.qml")
    QML.load(qml_engine,qml_file)

    exec()
    return
end


function my_function(d::JuliaDisplay, width, height)
    gr(grid = false, size=(Int64(round(width)),Int64(round(height))))
    plt = get_plot(shared)
    display(d, plt)
    return plt
end

function my_function(d::JuliaDisplay, width, height, savename::AbstractString)
    plt = my_function(d::JuliaDisplay, width, height)
    savefig(plt, savename)
end
