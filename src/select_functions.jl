function choose_data(a,d)
    index = broadcast(t -> true, 1:(size(a,1)))
    for key in keys(d)
        index = combine(index, d[key],a[key])
    end
    return a[index,:]
end

function combine(index, func::Function, values)
    return index & broadcast(func,values)
end

function combine{T}(index, els::AbstractArray{T,1}, values)
    func = t -> (t in els)
    return combine(index, func, values)
end

function combine(index, el, values)
    func = t -> (t == el)
    return combine(index, func, values)
end
