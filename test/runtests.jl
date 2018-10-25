using Test, LatticeSites


@testset "site type" begin
    for each in (Bit, Spin, Half)
        @test typeof(up(each)) == eltype(each)
    end
end

@testset "conversion" begin
end

@testset "rounding" begin
end

@testset "bits" begin
end

@testset "static array" begin
end
