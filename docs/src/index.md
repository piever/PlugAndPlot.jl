# PlugAndPlot.jl

## Overview

`PlugAndPlot.jl` allows to easily create and deploy a Graphical User Interface to draw statistical plots from a `DataFrame` interactively.
Once a `DataFrame` is loaded, `PlugAndPlot.jl` will create a GUI with widgets corresponding to the different functionalities of `StatPlots.jl` and `GroupedErrors.jl`. A second layer of widget simplifies data selection and splitting.
Once the plot is created, it can be modified using the usual `Plots.jl`
keywords.

Here is a screenshot from an example dataset:

![gui](https://user-images.githubusercontent.com/6333339/31089158-032c086a-a79b-11e7-9d41-9747a71f97a7.png)


## Installation

The package is not yet registered in Julia's package registry, and so it must
be installed typing the following command in the Julia REPL:

```julia
Pkg.clone("https://github.com/piever/PlugAndPlot.jl.git")
```

## Known issues

- Plotting on top of a previous plot (the button `Plot!`) is experimental and can behave strangely in combination with adding keywords or using sliders.
