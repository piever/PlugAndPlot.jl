function choose_data(shared)
    d = Dict()
    for s in shared.selectlist
        d[Symbol(s.name)] = [value.name for value in s.values if value.accepted]
    end
    for s in shared.selectvalues
        d[Symbol(s.name)] =
            (t -> (s.values[1].selected_value <= t <= s.values[2].selected_value))
    end
    choose_data(shared.df, d)
end

function choose_data(a,d)
    index = broadcast(t -> true, 1:length(a))
    for key in keys(d)
        combine!(index, d[key], columns(a, key))
    end
    return a[find(index)]
end

function combine!(index, func::Function, values)
    @. index = index & func(values)
end

function combine!{T}(index, els::AbstractArray{T,1}, values)
    func = t -> (string(t) in els)
    combine!(index, func, values)
end

function combine!(index, el, values)
    func = t -> (t == el)
    return combine!(index, func, values)
end
