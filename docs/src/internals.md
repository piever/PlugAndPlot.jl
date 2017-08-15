# Internals

Most of the hard work is outsourced to separate packages: mainly `QML.jl` and `StatPlots.jl`

## GUI design

The GUI is designed using `QML.jl` which allows Julia to communicate with the QML language for GUI design. `QML.jl` allows two-way data sharing between Julia and the GUI, so that the dataset, read by Julia, can give QML the list of relevant widgets to analyze the data.

## Plotting

Plotting is executed via the `StatPlots.jl` package. `Population` plots tap into the `groupapply` functionality whereas `Individual` plots have access to most of `StatPlots.jl` plotting recipes. See the [StatPlots README](https://github.com/JuliaPlots/StatPlots.jl/blob/master/README.md) for more information.
