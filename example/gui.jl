using ManipulateTable
using DataFrames
using StatPlots
using ClobberingReload
creload("ManipulateTable")
datafile = joinpath(Pkg.dir("ManipulateTable","example"), "school.csv")
build_window(datafile)

using QML
ManipulateTable.SpinBoxType("Ciao", [1,2])

build_window()
