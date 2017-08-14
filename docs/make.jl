using Documenter, PlugAndPlot

makedocs(
    format = :html,
    sitename = "PlugAndPlot",
    pages = [
        "Home" => "index.md",
    ]
)

deploydocs(
    repo = "github.com/piever/PlugAndPlot.jl.git",
    target = "build",
    julia  = "0.6",
    osname = "linux",
    deps   = nothing,
    make   = nothing
)
