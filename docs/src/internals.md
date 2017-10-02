# Internals

Most of the hard work is outsourced to separate packages: mainly `QML.jl`, `StatPlots.jl` and `GroupedErrors.jl`.

## GUI design

The GUI is designed using `QML.jl` which allows Julia to communicate with the QML language for GUI design. `QML.jl` allows two-way data sharing between Julia and the GUI, so that the dataset, read by Julia, can give QML the list of relevant widgets to analyze the data.

## Plotting

Plotting is executed via the [StatPlots.jl](https://github.com/JuliaPlots/StatPlots.jl) package. The data manipulation is implemented in [GroupedErrors.jl](https://github.com/piever/GroupedErrors.jl). The GroupedErrors package explains how to obtain the same plots (and some more) with code rather than a GUI.
