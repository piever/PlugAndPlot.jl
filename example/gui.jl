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

gr()

plot(sin, 0, 10)
ManipulateTable.get_plot(ManipulateTable.shared)

summary_df = by(ManipulateTable.shared.df, ManipulateTable.convert_error_type("across School")[2]) do dd_subject
    DataFrame(x = mean(dd_subject[:MAch]), y = mean(dd_subject[:MeanSES]))
end

plt = plot()
scatter!(plt, summary_df, :x, :y)

#test = ManipulateTable.shared
ManipulateTable.get_plot(ManipulateTable.shared)
