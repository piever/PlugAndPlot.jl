var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Introduction",
    "title": "Introduction",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#PlugAndPlot.jl-1",
    "page": "Introduction",
    "title": "PlugAndPlot.jl",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#Overview-1",
    "page": "Introduction",
    "title": "Overview",
    "category": "section",
    "text": "PlugAndPlot.jl allows to easily create and deploy a Graphical User Interface to draw statistical plots from a DataFrame interactively. Once a DataFrame is loaded, PlugAndPlot.jl will create a GUI with widgets corresponding to the different functionalities of StatPlots.jl and GroupedErrors.jl. A second layer of widget simplifies data selection and splitting. Once the plot is created, it can be modified using the usual Plots.jl keywords.Here is a screenshot from an example dataset:(Image: gui)"
},

{
    "location": "index.html#Installation-1",
    "page": "Introduction",
    "title": "Installation",
    "category": "section",
    "text": "The package is not yet registered in Julia's package registry, and so it must be installed typing the following command in the Julia REPL:Pkg.clone(\"https://github.com/piever/PlugAndPlot.jl.git\")"
},

{
    "location": "index.html#Known-issues-1",
    "page": "Introduction",
    "title": "Known issues",
    "category": "section",
    "text": "Plotting on top of a previous plot (the button Plot!) is experimental and can behave strangely in combination with adding keywords or using sliders."
},

{
    "location": "getting_started.html#",
    "page": "Getting Started",
    "title": "Getting Started",
    "category": "page",
    "text": ""
},

{
    "location": "getting_started.html#Getting-started-1",
    "page": "Getting Started",
    "title": "Getting started",
    "category": "section",
    "text": ""
},

{
    "location": "getting_started.html#PlugAndPlot.build_window",
    "page": "Getting Started",
    "title": "PlugAndPlot.build_window",
    "category": "Function",
    "text": "build_window(; kwargs...)\n\nStarts the GUI asking for a suitable csv file.\n\n\n\nbuild_window(datafile::AbstractString; kwargs...)\n\nReads a csv file and starts build_window on the corresponding DataFrame\n\n\n\nbuild_window(dataset::AbstractDataFrame; nbox = 5)\n\nCreates a GUI to analyze a DataFrame interactively. Data can be selected either on continuous columns, with SpinBoxes or on discrete columns with checkboxes, provided there are less than nbox entries.\n\n\n\n"
},

{
    "location": "getting_started.html#Loading-the-data-1",
    "page": "Getting Started",
    "title": "Loading the data",
    "category": "section",
    "text": "To load the data, simply type the following command in the Julia REPL:using PlugAndPlot\nbuild_window()you will then be asked to choose for a csv file with your data. It is important to store your data as a tabular dataset. In particularData is represented as a series of columns with equal length, with values separated by commas\nThe first row is assumed to be the header\nMissing data is not supported yetbuild_window"
},

{
    "location": "getting_started.html#Choosing-the-analysis-1",
    "page": "Getting Started",
    "title": "Choosing the analysis",
    "category": "section",
    "text": "The choice of a statistical analysis is just the same as in GroupedErrors. Below it is explained step by step."
},

{
    "location": "getting_started.html#Selecting-the-x-variable-1",
    "page": "Getting Started",
    "title": "Selecting the x variable",
    "category": "section",
    "text": "It must be a column of your dataset."
},

{
    "location": "getting_started.html#Selecting-the-y-variable-1",
    "page": "Getting Started",
    "title": "Selecting the y variable",
    "category": "section",
    "text": "It can be either a column of your dataset or an analysis to effectuate on the x variable (for example, computing its densiy or hazard)."
},

{
    "location": "getting_started.html#Deciding-the-axis-type-1",
    "page": "Getting Started",
    "title": "Deciding the axis type",
    "category": "section",
    "text": "Axis type pointbypoint is needed when you want to plot x against y, and it only makes sense when y is also a column of your data. The widget dataperpoint asks whether you want to split-apply-combine your data before plotting. The pointbypoint option means: \"plot as is\". Otherwise, it is possible to group by one of your data columns and only plot some summary variable (e.g. the mean). The summary function can be defined below the x axis and y axis widgets. mean is the default. To also get an estimate of the variability, you can put a tuple of two functions, the first being the average and the second the variability, i.e. (mean, sem).Axis type continuous is recommended when dealing with a continuous x variable. The built-in analysis functions will then use their continuous version (for example, density will use kernel density estimation and x versus y plots will use LOESS regression). For this to work, x needs to be a numeric type. For analysis where smoothing make sense, the smoothing widget allows to pass from thinner to coarser smoothing.Axis type discrete means that the x axis will treat the x values individually. For example, an x versus y plot will plot, for every value of x, the average of the y values for datapoints with the corresponding value of x. Different estimator of y rather than mean (i.e. median) can be chosen below the y axis widget.Axis type binned bins the x data and simply acts like the discrete axis type after the data is binned. Number of bins can be decided using the smoothing slider."
},

{
    "location": "getting_started.html#Deciding-how-to-compute-the-variability-1",
    "page": "Getting Started",
    "title": "Deciding how to compute the variability",
    "category": "section",
    "text": "This section only makes sense if your axis type is not pointbypoint. In this case several ways of estimating variability are proposed:none: do not estimate variability\nacross var where var is one of your colomuns: group by that column, compute the desired function for each group, plot the mean across groups, error is s.e.m. across groups\nacross same as before, except it computes the error across all observation (beware: this does generally not make sense in combination with a continuous axis)\nbootstrap: simulates 1000 fake datasets distributed like yours, computes the desired function on each of them, then plots mean across simulated datasets, error is standard deviation across simulated datasets (see Non-parametric bootstrap)"
},

{
    "location": "getting_started.html#Selecting/splitting-data-1",
    "page": "Getting Started",
    "title": "Selecting/splitting data",
    "category": "section",
    "text": "Splitting data is extremely simple. Variables with less thank nbox = 5 possible values appear as toggle buttons. If toggled, the data will be split on that variable. You can toggle as many of those as you want.To select data, if the variable has few possible values, you'll see all the values listed as a series of checkboxes. Uncheck the values you want to exclude. For continuous data, you are provided two spinboxes that you can use to select the minimum and maximum acceptable values."
},

{
    "location": "getting_started.html#Drawing/saving-plots-1",
    "page": "Getting Started",
    "title": "Drawing/saving plots",
    "category": "section",
    "text": "To draw a plot, simply press the PLOT button. All the valid keywords for Plots.jl can be added in the textbox below the plot, here for example the added keywords are color = [:black :blue], legend = :topleft:(Image: gui)There is an experimental button PLOT! to plot on top of an existing plots, but it's implementation is not very robust and may change.To save the plot, simply press the SAVE button and it will open a saving dialog. The extension you give to the filename will determine its format (i.e. \"myplot.png\" will be saved as png whereas \"myplot.svg\" will be saved in vectorial format)."
},

{
    "location": "internals.html#",
    "page": "Internals",
    "title": "Internals",
    "category": "page",
    "text": ""
},

{
    "location": "internals.html#Internals-1",
    "page": "Internals",
    "title": "Internals",
    "category": "section",
    "text": "Most of the hard work is outsourced to separate packages: mainly QML.jl, StatPlots.jl and GroupedErrors.jl."
},

{
    "location": "internals.html#GUI-design-1",
    "page": "Internals",
    "title": "GUI design",
    "category": "section",
    "text": "The GUI is designed using QML.jl which allows Julia to communicate with the QML language for GUI design. QML.jl allows two-way data sharing between Julia and the GUI, so that the dataset, read by Julia, can give QML the list of relevant widgets to analyze the data."
},

{
    "location": "internals.html#Plotting-1",
    "page": "Internals",
    "title": "Plotting",
    "category": "section",
    "text": "Plotting is executed via the StatPlots.jl package. The data manipulation is implemented in GroupedErrors.jl. The GroupedErrors package explains how to obtain the same plots (and some more) with code rather than a GUI."
},

]}
