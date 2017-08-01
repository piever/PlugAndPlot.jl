mutable struct Path
    file::String
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

mutable struct ComboBoxEntry
    value::String
end

mutable struct ComboBoxType
    name::String
    chosen_value::String
    options::Vector{ComboBoxEntry}
    _options::ListModel
    ComboBoxType(name, options) = new(name, options[1].value, options, ListModel(options))
end
