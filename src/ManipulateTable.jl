module ManipulateTable

using QML, StatPlots, DataFrames

export choose_data, build_window

include("types.jl")
include("select_functions.jl")
include("build_window.jl")

end # module
