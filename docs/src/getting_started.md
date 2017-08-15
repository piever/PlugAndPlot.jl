# Getting started

## Loading the data

To load the data, simply type the following command in the Julia REPL:

```julia
using PlugAndPlot
build_window()
```
you will then be asked to choose for a `csv` file with your data.
It is important to store your data as a tabular dataset. In particular
- Data is represented as a series of columns with equal length, with values separated by commas
- The first row is assumed to be the header
- Missing data is not supported yet

```@docs
build_window
```
