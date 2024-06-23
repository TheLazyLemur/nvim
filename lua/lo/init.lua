local lo = {}

lo.filter = function(collection, predicate)
    local result = {}
    for _, v in pairs(collection) do
        if predicate(v) then
            table.insert(result, v)
        end
    end
    return result
end

lo.map = function(collection, transform)
    local result = {}
    for i, v in pairs(collection) do
        table.insert(result, transform(i, v))
    end
    return result
end

lo.to_map = function(collection, keyFunc)
    local result = {}
    for _, v in pairs(collection) do
        local k = keyFunc(v)
        if result[k] == nil then
            result[k] = {}
        end
        table.insert(result[k], v)
    end
    return result
end

lo.reduce = function(collection, initial, transform)
    local result = initial
    for _, v in pairs(collection) do
        result = transform(result, v)
    end
    return result
end

lo.for_each = function(collection, transform)
    for i, v in pairs(collection) do
        transform(i, v)
    end
end

lo.index_of = function(collection, valueFunc)
    for i, v in pairs(collection) do
        if valueFunc(v) then
            return i
        end
    end
end

lo.indexes_of = function(collection, valueFunc)
    local result = {}
    for i, v in pairs(collection) do
        if valueFunc(v) then
            table.insert(result, i)
        end
    end
    return result
end

return lo
