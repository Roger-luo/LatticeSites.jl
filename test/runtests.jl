
# @testset "Check Type Property" begin
#
#     # check default eltype
#     @test eltype(Bit) == Float64
#     @test eltype(Spin) == Float64
#     @test eltype(Half) == Float64
#
#     # check up down type
#     for each in (Bit, Spin, Half)
#         @test typeof(up(each)) == eltype(each)
#     end
#
# end
#
# @testset "Check Initialization" begin
#     # check initial
#     SiteBit = Sites(Bit, 3, 3)
#     SiteSpin = Sites(Spin, 3, 3)
#     SiteHalf = Sites(Half, 3, 3)
#
#     @test SiteBit.data == zeros(eltype(Bit), 3, 3)
#     @test SiteSpin.data == -ones(eltype(Spin), 3, 3)
#     @test SiteHalf.data == eltype(Half)(-0.5) * ones(eltype(Half), 3, 3)
# end
#
# @testset "Check Array Interface" begin
#
#     SHAPE = (3, 4)
#     LENGTH = prod(SHAPE)
#     SiteA = Sites(Bit, SHAPE)
#
#     @test eltype(SiteA) == eltype(Bit)
#     @test length(SiteA) == LENGTH
#     @test ndims(SiteA) == length(SHAPE)
#     @test size(SiteA) == SHAPE
#     @test size(SiteA, 1) == SHAPE[1]
#     @test size(SiteA, 2) == SHAPE[2]
#     @test axes(SiteA) == axes(SiteA.data)
#     @test axes(SiteA, 1) == axes(SiteA.data, 1)
#     @test eachindex(SiteA) == eachindex(SiteA.data)
#     @test stride(SiteA, 1) == stride(SiteA.data, 1)
#     @test strides(SiteA) == strides(SiteA.data)
#     @test getindex(SiteA, 1, 1) == SiteA.data[1, 1]
#
#     setindex!(SiteA, 2, 1, 1)
#     @test SiteA[1, 1] == 2
# end
#
# @testset "Check Site Interface" begin
#     SHAPE = (3, 4)
#     SiteA = Sites(Bit, SHAPE)
#     SiteB = copy(SiteA)
#
#     # check if this copy is shallow
#     rand!(SiteA)
#     @test SiteB[1, 1] == 0
#
#     reset!(SiteA)
#     @test SiteA.data == zeros(eltype(Bit), SHAPE)
#
#     SiteB[1, 1] = up(Bit)
#     @test flip!(SiteA, 1, 1) == SiteB
# end
#
# @testset "Check Site Conversions" begin
#
#     for LT in (Bit, Spin, Half)
#         A = Sites(LT, 4, 4)
#         set!(A, 142)
#
#         @test convert(Int, A) == 142
#
#         # will throw InexactError if Sites is too large
#         @test_throws InexactError convert(Int8, A)
#     end
#
# end

using Test, LatticeSites, Random
using StaticArrays

space = HilbertSpace{Bit{Float64}}(2, 2)

[copy(each) for each in space]

function checkcheck(s)
    count = 0
    list = Array[]
    for each in s
        if count > 10
            break
        end
        push!(list, copy(each))
        count += 1
    end
    list
end

checkcheck(space)
iterate(space)
[copy(each) for each in space]
space
length(space)

collect(space)
function bench_static(s)
    list = Vector{Int}(undef, length(s))
    for (i, each) in enumerate(s)
        list[i] = convert(Int, each)
    end
    list
end

function bench_dynamic(s)
    list = Vector{Int}(undef, length(s))
    c = downs(Bit{Float64})
    for i in 1:length(s)
        list[i] = convert(Int, carrybit!(c))
    end
    list
end

@allocated bench_static(space)
@allocated bench_dynamic(space)

using BenchmarkTools

@benchmark bench_static(space)

@benchmark bench_dynamic(space)

function carrybit!(a::Array{L}) where L
    @inbounds for i in eachindex(a)
        if a[i] == up(L)
            a[i] = down(L)
        else
            a[i] = up(L)
            break
        end
    end
    a
end



c = downs(Bit{Float64}, 2, 2)

convert(Int, c)
carrybit!(c)


a = convert(SArray{Tuple{2, 2}, Bit{Float64}}, 0)
convert(SArray{Tuple{2, 2}, Bit{Float64}, 2}, 15)

@which size(typeof(a))

LatticeSites.get_bit(Float64, 15, 2)
string(15, base=2)

ups(SMatrix{2, 2})

up(Bit{Float64})

convert(Int, ups(SMatrix{2, 2}))
convert(Int, Bit(1.0))
