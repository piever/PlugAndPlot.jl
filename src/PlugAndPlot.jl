__precompile__(false)
module PlugAndPlot

using GroupedErrors
using DataFrames, TextParse, IndexedTables
using QML, StatPlots
gr()

export choose_data, build_window

include("types.jl")
include("select_functions.jl")
include("build_window.jl")
include("build_plot.jl")
end # module
