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
# dataset = CSV.read(datafile, nullable = false, weakrefstrings = false)
dataset = readtable(datafile)
build_window(datafile)
shared.df

 choose_data(shared)

 choose_data(, d)
end
d = Dict()
for s in shared.selectlist
    d[Symbol(s.name)] = [value.name for value in s.values if value.accepted]
end
for s in shared.selectvalues
    d[Symbol(s.name)] = (t -> (s.values[1].selected_value <= t <= s.values[2].selected_value))
end
a = shared.df
 index = broadcast(t -> true, 1:(size(a,1)))
 for key in keys(d)
     index .= combine(index, d[key],a[key])
 end

index
