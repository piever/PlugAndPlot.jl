mutable struct TextBoxEntry
    value::String
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

mutable struct SpinBoxEntry{T<:Real}
    selected_value::T
    min_value::T
    max_value::T
end

mutable struct SpinBoxType{T<:Real}
    name::String
    values::Vector{SpinBoxEntry{T}}
    _values::ListModel
    SpinBoxType{T}(name, options::Vector{SpinBoxEntry{T}}) where {T<:Real} =
        new(name, options, ListModel(options))
end

SpinBoxType(name, values::Vector{T}) where T<:Real =
    SpinBoxType{T}(name, SpinBoxEntry.(values, values[1], values[2]))
