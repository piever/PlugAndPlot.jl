using PlugAndPlot
using DataFrames
using StatPlots
using ClobberingReload
creload("PlugAndPlot")
datafile = joinpath(Pkg.dir("PlugAndPlot","example"), "school.csv")
build_window(datafile)

using QML
PlugAndPlot.SpinBoxType("Ciao", [1,2])
build_window()
