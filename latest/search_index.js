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
    "text": "PlugAndPlot.jl allows to easily create and deploy a Graphical User Interface to draw statistical plots from a DataFrame interactively. Once a DataFrame is loaded, PlugAndPlot.jl will create a GUI with widgets corresponding to the different functionalities of StatPlots.jl. A second layer of widget simplifies data selection and splitting. Once the plot is created, it can be modified using the usual Plots.jl keywords.Here is a screenshot from an example dataset:(Image: )"
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
    "text": "Pressing Tab can cause a segmentation fault. The issue is being investigate, but for the time being it is recommended to not press Tab while using PlugAndPlot.jl.\nPlotting on top of a previous plot (the button Plot!) is experimental and can behave strangely in combination with adding keywords or using sliders."
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
    "text": "Most of the hard work is outsourced to separate packages: mainly QML.jl and StatPlots.jl"
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
    "text": "Plotting is executed via the StatPlots.jl package. Population plots tap into the groupapply functionality whereas Individual plots have access to most of StatPlots.jl plotting recipes. See the StatPlots README for more information."
},

]}
