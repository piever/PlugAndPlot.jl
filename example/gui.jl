using ManipulateTable
using QML
using RDatasets
using DataFrames
#using ClobberingReload
#creload("ManipulateTable")
school = RDatasets.dataset("mlmRev","Hsb82");


selectlist = [DataColumn(string(name), union(school[name]))
    for name in names(school) if length(union(school[name])) < 5]

selectlist

# run QML window
qview = init_qquickview()
@qmlset qmlcontext().selectModel = ListModel(selectlist)
qml_file = joinpath(dirname(Base.source_path()), "gui.qml")
set_source(qview, qml_file)
QML.show(qview)

exec()
return
