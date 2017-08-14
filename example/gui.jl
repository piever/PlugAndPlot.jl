using PlugAndPlot
using DataFrames
using StatPlots
gr()
scatter(rand(100))
savefig("/Users/pietro/Desktop/testgr.pdf")
using ClobberingReload
using TextParse
using CSV
creload("PlugAndPlot")
datafile = joinpath(Pkg.dir("PlugAndPlot","example"), "school.csv")
# cols, name_cols = csvread(datafile; header_exists = true)
# dataset = DataFrame(collect(cols), Symbol.(name_cols))
dataset = CSV.read(datafile, nullable = false, weakrefstrings = false)
#dataset = readtable(datafile)
build_window(dataset)
using DataFrames
import RDatasets
using StatPlots
gr()
school = RDatasets.dataset("mlmRev","Hsb82");
grp_error = groupapply(:CSES, school, :MAch; span = 0.7)
plot(grp_error, line = :path)
