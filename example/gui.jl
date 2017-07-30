using ManipulateTable
using DataFrames
using StatPlots
using ClobberingReload
creload("ManipulateTable")
datafile = joinpath(Pkg.dir("ManipulateTable","example"), "school.csv")
build_window(datafile)
