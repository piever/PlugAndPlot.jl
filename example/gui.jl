using Base.Test
using QML

# Julia Fruit model item. Each field is automatically a role, by default
mutable struct DataColumn
  name::String
  attributes::ListModel
end

# Attributes must have a description and are nested model items
mutable struct Attribute
  description::String
end

# Construct using attributes from an array of QVariantMap, as in the append call in QML
function DataColumn(name, descriptions::Array{T}) where T<:AbstractString
  return DataColumn(name, ListModel(Attribute.(descriptions)))
end

# Use a view, since no ApplicationWindow is provided in the QML
qview = init_qquickview()


# Our initial data
selectlist = [
  DataColumn("Subject", ["1", "2", "3"]),
  DataColumn("Treatment",  ["true", "false"])]

# Set a context property with our listmodel
@qmlset qmlcontext().selectModel = ListModel(selectlist)
qml_file = joinpath(dirname(Base.source_path()), "gui.qml")
set_source(qview, qml_file)
QML.show(qview)

exec()

return
