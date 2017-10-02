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

## Choosing the analysis

The choice of a statistical analysis is just the same as in [GroupedErrors](https://github.com/piever/GroupedErrors.jl). Below it is explained step by step.

### Selecting the x variable

It must be a column of your dataset.

### Selecting the y variable

It can be either a column of your dataset or an analysis to effectuate on the `x` variable (for example, computing its `densiy` or `hazard`).

### Deciding the axis type

Axis type `pointbypoint` is needed when you want to plot `x` against `y`, and it only makes sense when `y` is also a column of your data. The widget `dataperpoint` asks whether you want to `split-apply-combine` your data before plotting. The `pointbypoint` option means: "plot as is". Otherwise, it is possible to group by one of your data columns and only plot some summary variable (e.g. the mean).
The summary function can be defined below the `x axis` and `y axis` widgets. `mean` is the default. To also get an estimate of the variability, you can put a tuple of two functions, the first being the average and the second the variability, i.e. `(mean, sem)`.

Axis type `continuous` is recommended when dealing with a continuous `x` variable. The built-in analysis functions will then use their continuous version (for example, `density` will use kernel density estimation and `x` versus `y` plots will use LOESS regression). For this to work, `x` needs to be a numeric type. For analysis where smoothing make sense, the `smoothing` widget allows to pass from thinner to coarser smoothing.

Axis type `discrete` means that the `x` axis will treat the `x` values individually. For example, an `x` versus `y` plot will plot, for every value of `x`, the average of the `y` values for datapoints with the corresponding value of `x`. Different estimator of `y` rather than mean (i.e. `median`) can be chosen below the `y axis` widget.

Axis type `binned` bins the `x` data and simply acts like the `discrete` axis type after the data is binned. Number of bins can be decided using the `smoothing` slider.

### Deciding how to compute the variability

This section only makes sense if your axis type is not `pointbypoint`. In this case several ways of estimating variability are proposed:

- `none`: do not estimate variability
- `across var` where var is one of your colomuns: group by that column, compute the desired function for each group, plot the mean across groups, error is s.e.m. across groups
- `across` same as before, except it computes the error across all observation (beware: this does generally not make sense in combination with a continuous axis)
- `bootstrap`: simulates 1000 fake datasets distributed like yours, computes the desired function on each of them, then plots mean across simulated datasets, error is standard deviation across simulated datasets (see [Non-parametric bootstrap](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)))

## Selecting/splitting data

Splitting data is extremely simple. Variables with less thank `nbox = 5` possible values appear as toggle buttons. If toggled, the data will be split on that variable. You can toggle as many of those as you want.

To select data, if the variable has few possible values, you'll see all the values listed as a series of checkboxes. Uncheck the values you want to exclude. For continuous data, you are provided two spinboxes that you can use to select the minimum and maximum acceptable values.

## Drawing/saving plots

To draw a plot, simply press the `PLOT` button. All the valid keywords for Plots.jl can be added in the textbox below the plot, here for example the added keywords are `color = [:black :blue], legend = :topleft`:

![gui](https://user-images.githubusercontent.com/6333339/31089158-032c086a-a79b-11e7-9d41-9747a71f97a7.png)


There is an experimental button `PLOT!` to plot on top of an existing plots, but it's implementation is not very robust and may change.

To save the plot, simply press the `SAVE` button and it will open a saving dialog. The extension you give to the filename will determine its format (i.e. "myplot.png" will be saved as png whereas "myplot.svg" will be saved in vectorial format).
