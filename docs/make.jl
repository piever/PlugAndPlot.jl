using Documenter, PlugAndPlot

makedocs()

deploydocs(
    repo = "github.com/piever/PlugAndPlot.jl.git",
    julia  = "0.6",
    osname = "osx"
)
