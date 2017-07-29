using ManipulateTable
using DataFrames
using StatPlots
#using FileIO
using ClobberingReload
#creload("ManipulateTable")
datafile = joinpath(dirname(Base.source_path()), "school.csv")
df, selectlist, plotvalues = build_window(datafile)
plt = get_plot(df, selectlist, plotvalues)
display(plt)
