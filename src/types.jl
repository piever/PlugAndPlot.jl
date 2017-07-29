mutable struct Path
    file::String
end

function clean(p::Path)
    (p.file == "") && error("No file selected")
    return split(p.file,":/")[2]
end

mutable struct Value
  name::String
  accepted::Bool
end

mutable struct Column
  name::String
  split::Bool
  values::Vector{Value}
  _values::ListModel
  Column(name, split, values) = new(name, split, values, ListModel(values))
end

Column(name, values::AbstractArray) = Column(name, false, Value.(collect(values), true))
