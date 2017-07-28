using Base.Test
using QML

# Attributes must have a description and are nested model items
mutable struct Attribute
  description::String
  accepted::Bool
end
# Julia Fruit model item. Each field is automatically a role, by default
struct DataColumn
  name::String
  attributes::ListModel
  _attributes::Array{Attribute}
end



# Construct using attributes from an array of QVariantMap, as in the append call in QML
function DataColumn(name, descriptions::Array{T}) where T<:AbstractString
    _attributes = Attribute.(descriptions, true)
    return DataColumn(name, ListModel(_attributes), _attributes)
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

exec_async()
