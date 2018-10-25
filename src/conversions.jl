function Base.convert(::Type{ST}, x::T2) where {T1 <: Number, T2 <: Number, ST <: BinarySite{T1}}
    round(ST, T1(x))
end

for ST1 in [:Bit, :Spin, :Half]
    @eval Base.convert(::Type{$ST1{T}}, x::$ST1) where T = $ST1{T}(T(x.value))
end

Base.convert(::Type{ST1}, x::ST2) where {ST1 <: BinarySite, ST2 <: BinarySite} =
    x == up(ST2) ? up(ST1) : down(ST1)

Base.convert(::Type{SA}, x::Int) where {S, T, N, SA <: StaticArray{S, Bit{T}, N}} =
    _convert(Size(SA), eltype(SA), SA, x)

get_bit(::Type{T}, x::Int, i::Int) where T = T((x >> (i - 1)) & 1)

@generated function _convert(::Size{s}, ::Type{Bit{T}}, ::Type{SA}, x::Int) where {s, T, SA}
    v = [:(get_bit($T, x, $i)) for i = 1:prod(s)]
    return quote
        @_inline_meta
        $SA(tuple($(v...)))
    end
end

# Arrays
for IntType in (Int8, Int16, Int32, Int64, Int128, BigInt)

@eval Base.convert(::Type{$IntType}, x::Bit{T}) where T = convert($IntType, x.value)

@eval begin
        function Base.convert(::Type{$IntType}, x::AbstractArray{Bit{T}, N}) where {T, N}
            if sizeof($IntType) * 8 < length(x)
                throw(InexactError(:convert, $IntType, x))
            end

            sum(convert($IntType, each) << (i-1) for (i, each) in enumerate(x))
        end

        function Base.convert(::Type{$IntType}, x::AbstractArray{Spin{T}, N}) where {T, N}
            if sizeof($IntType) * 8 < length(x)
                throw(InexactError(:convert, $IntType, x))
            end

            sum(convert($IntType, div(each+1, 2)) << (i-1) for (i, each) in enumerate(x))
        end

        function Base.convert(::Type{$IntType}, x::AbstractArray{Half{T}, N}) where {T, N}
            if sizeof($IntType) * 8 < length(x)
                throw(InexactError(:convert, $IntType, x))
            end

            sum(convert($IntType, each+0.5) << (i-1) for (i, each) in enumerate(x))
        end
    end
end
