module PlugAndPlot

using QML, StatPlots, DataFrames, TextParse, GroupedErrors, IndexedTables
gr()

export choose_data, build_window

include("types.jl")
include("select_functions.jl")
include("build_window.jl")
include("build_plot.jl")
end # module
