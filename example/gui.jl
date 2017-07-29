using ManipulateTable
using DataFrames
#using FileIO
using ClobberingReload
creload("ManipulateTable")
datafile = joinpath(dirname(Base.source_path()), "school.csv")
selectdata, selectlist = build_window(datafile)
