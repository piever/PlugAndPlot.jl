# PlugAndPlot.jl

## Overview

`PlugAndPlot.jl` allows to easily create and deploy a Graphical User Interface to draw statistical plots from a `DataFrame` interactively.
Once a `DataFrame` is loaded, `PlugAndPlot.jl` will create a GUI with widgets corresponding to the different functionalities of `StatPlots.jl`. A second layer of widget simplifies data selection and splitting.
Once the plot is created, it can be modified using the usual `Plots.jl`
keywords.

Here is a screenshot from an example dataset:

![](https://user-images.githubusercontent.com/6333339/29314520-37bf1a82-81b6-11e7-8b22-d2eb9c3c70c5.png)


## Installation

The package is not yet registered in Julia's package registry, and so it must
be installed typing the following command in the Julia REPL:

```julia
Pkg.clone("https://github.com/piever/PlugAndPlot.jl.git")
```

This package may depend on recent features of `StatPlots.jl`. For all the features to work, it is recommended to be on the latest (unreleased) StatPlots version:

```julia
Pkg.checkout("StatPlots")
```

## Known issues

- Pressing `Tab` can cause a segmentation fault. The issue is being investigate, but for the time being it is recommended to not press `Tab` while using `PlugAndPlot.jl`.
- Plotting on top of a previous plot (the button `Plot!`) is experimental and can behave strangely in combination with adding keywords or using sliders.
