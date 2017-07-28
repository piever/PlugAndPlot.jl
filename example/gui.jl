using Base.Test
using QML

# Julia Fruit model item. Each field is automatically a role, by default
type Fruit
  name::String
  cost::Float64
  attributes::ListModel
end

# Attributes must have a description and are nested model items
type Attribute
  description::String
end

# Construct using attributes from an array of QVariantMap, as in the append call in QML
function Fruit(name, cost, attributes::Array)
  return Fruit(name, cost, ListModel([Attribute(a["description"]) for a in attributes]))
end

# Use a view, since no ApplicationWindow is provided in the QML
qview = init_qquickview()


# Our initial data
fruitlist = [
  Fruit("Apple", 2.45, ListModel([Attribute("Core"), Attribute("Decous")])),
  Fruit("Banana", 1.95, ListModel([Attribute("Tropical"), Attribute("Seedless")])),
  Fruit("Cumquat", 3.25, ListModel([Attribute("Citrus")])),
  Fruit("Durian", 9.95, ListModel([Attribute("Tropical"), Attribute("Smelly")]))]

# Set a context property with our listmodel
@qmlset qmlcontext().fruitModel = ListModel(fruitlist)
qml_file = joinpath(dirname(Base.source_path()), "gui.qml")
set_source(qview, qml_file)
QML.show(qview)

exec()

return
