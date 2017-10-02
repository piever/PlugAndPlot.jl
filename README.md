# PlugAndPlot

[![Build Status](https://travis-ci.org/piever/PlugAndPlot.jl.svg?branch=master)](https://travis-ci.org/piever/PlugAndPlot.jl)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://piever.github.io/PlugAndPlot.jl/latest/)

Goal: build a QML GUI to create statistical plots from a DataFrame, based on StatPlots and GroupedErrors.

While most of the plots can actually be achieved by typing reasonably simple commands from [GroupedErrors](https://github.com/piever/GroupedErrors.jl), this package is relevant for the following two use-cases:

- users not very comfortable with coding
- completely exploratory data analysis on a dataset with a large number of columns where doing all plots by hand would be too time consuming.

In either case, it is recommended to also check out [GroupedErrors](https://github.com/piever/GroupedErrors.jl) to better understand what's going out under the hood.

The qml code is largely inspired to the examples of the excellent [QML.jl](https://github.com/barche/QML.jl) package.

## Example usage

This is what it looks like:

![gui](https://user-images.githubusercontent.com/6333339/31089158-032c086a-a79b-11e7-9d41-9747a71f97a7.png)



See the docs for a more thorough explanation.
