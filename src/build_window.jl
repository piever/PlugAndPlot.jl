mutable struct Shared
    df::DataFrame
    selectvalues::Vector{SpinBoxType}
    selectlist::Vector{Column}
    plotvalues::Vector{ComboBoxType}
    plotkwargs::TextBoxEntry
    smoother::SliderEntry
    plt::Plots.Plot{Plots.GRBackend}
end
shared = Shared(DataFrame(), SpinBoxType[], Column[], ComboBoxType[], TextBoxEntry(""), SliderEntry(0.0), plot())

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
function build_window(datafile::AbstractString; kwargs...)
    cols, name_cols = csvread(datafile; header_exists = true)
    dataset = DataFrame(collect(cols), Symbol.(name_cols))
    return build_window(dataset; kwargs...)
end
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
    @qmlset qmlcontext().smoother = shared.smoother
    qmlfunction("do_plot", PlugAndPlot.do_plot)
    qmlfunction("do_plot_inplace", PlugAndPlot.do_plot!)
    qmlfunction("save_plot", PlugAndPlot.save_plot)
    qml_file = joinpath(Pkg.dir("PlugAndPlot","src"), "QML", "gui.qml")
    QML.load(qml_engine,qml_file)

    exec()
    return
end


function do_plot(d::JuliaDisplay, width, height)
    shared.plt = plot()
    do_plot!(d, width, height)
end

function do_plot!(d::JuliaDisplay, width, height)
    gr(grid = false, size=(Int64(round(width)),Int64(round(height))))
    get_plot!(shared)
    display(d, shared.plt)
end

save_plot(savename::AbstractString) =  savefig(shared.plt, savename)
