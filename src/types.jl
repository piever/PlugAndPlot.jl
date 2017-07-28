mutable struct Attribute
  description::String
  accepted::Bool
end

struct DataColumn{T<:Union{Array{Attribute},ListModel}}
  name::String
  attributes::T
end

function DataColumn(name, descriptions::AbstractArray{T}) where T<:AbstractString
    return DataColumn(name, Attribute.(collect(descriptions), true))
end

function QML.ListModel(v::Array{DataColumn{T}}) where {T<:Array{Attribute}}
    w = [DataColumn(dc.name,ListModel(dc.attributes)) for dc in v]
    return ListModel(w)
end
