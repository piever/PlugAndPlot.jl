using Documenter, PlugAndPlot

makedocs(
    format = :html,
    sitename = "PlugAndPlot",
    authors = "Pietro Vertechi",
    pages = [
        "Introduction" => "index.md",
        "Getting Started" => "getting_started.md",
        "Internals" => "internals.md",
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
