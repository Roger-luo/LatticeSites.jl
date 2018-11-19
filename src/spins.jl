export up, down, Bit, Spin, Half

abstract type AbstractSite{T} end

Base.show(io::IO, s::AbstractSite) = show(io, value(s))

Base.:(==)(lhs::AbstractSite, rhs::Number) = value(lhs) == rhs
Base.:(==)(lhs::Number, rhs::AbstractSite) = lhs == value(rhs)

abstract type BinarySite{T} <: AbstractSite{T} end

"""
    up(site) -> site
    up(site_type) -> site
up tag for this label. e.g. `1` for `Bit`, `0.5` for `Half`.
"""
function up end

"""
    down(site) -> site
    down(site_type) -> site
down tag for this label. e.g. `0` for `Bit`, `-0.5` for `Half`.
"""
function down end

value(s::BinarySite) = s.value

struct Bit{T} <: BinarySite{T}
    value::T
end

struct Spin{T} <: BinarySite{T}
    value::T
end

struct Half{T} <: BinarySite{T}
    value::T
end

up(::Type{Bit{T}}) where T = Bit(one(T))
up(::Type{Spin{T}}) where T = Spin(one(T))
up(::Type{Half{T}}) where T = Half(T(0.5))

down(::Type{Bit{T}}) where T = Bit(zero(T))
down(::Type{Spin{T}}) where T = Spin(-one(T))
down(::Type{Half{T}}) where T = Half(-T(0.5))

# Base.rand(::Type{Bit{T}}) where T = Bit{T}(rand(Bool))
# Base.rand(::Type{Spin{T}}) where T = Spin{T}(2 * rand(Bool) - 1)
# Base.rand(::Type{Half{T}}) where T = Half{T}(rand(Bool) - 0.5)

Base.length(::BinarySite) = 1
Base.iterate(x::BinarySite) = (x, nothing)
Base.iterate(x::BinarySite, state) = nothing

Random.rand(rng::Random.AbstractRNG, sp::Random.SamplerType{Bit{T}}) where T = Bit{T}(rand(rng, Bool))
Random.rand(rng::Random.AbstractRNG, sp::Random.SamplerType{Spin{T}}) where T = Spin{T}(2 * rand(rng, Bool) - 1)
Random.rand(rng::Random.AbstractRNG, sp::Random.SamplerType{Half{T}}) where T = Half{T}(rand(rng, Bool) - 0.5)

Base.to_index(A::AbstractArray, i::Bit) = value(i) + 1
Base.to_index(A::AbstractArray, i::Spin) = Int(0.5 * (value(i) + 1) + 1)
Base.to_index(A::AbstractArray, i::Half) = Int(value(i) + 1.5)

Base.to_index(A::AbstractArray, I::AbstractArray{Bit{T}, N}) where {T, N} = reinterpret(Int, I) .+ 1

Base.getindex(t::Tuple, i::Bit) = getindex(t, value(i) + 1)
Base.getindex(t::Tuple, i::Spin) = getindex(t, Int(div(value(i) + 1, 2) + 1))

include("roundings.jl")
include("conversions.jl")
include("arraymath.jl")
