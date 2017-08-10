using PlugAndPlot
using DataFrames
using StatPlots
using ClobberingReload
using TextParse
using CSV
creload("PlugAndPlot")
datafile = joinpath(Pkg.dir("PlugAndPlot","example"), "school.csv")
# cols, name_cols = csvread(datafile; header_exists = true)
# dataset = DataFrame(collect(cols), Symbol.(name_cols))
# dataset = CSV.read(datafile, nullable = false, weakrefstrings = false)
# dataset = readtable(datafile)
build_window(datafile)
