# LatticeSites.jl

[![Build Status](https://travis-ci.org/Roger-luo/LatticeSites.jl.svg?branch=master)](https://travis-ci.org/Roger-luo/LatticeSites.jl)

Type for different kind of sites on different lattices.

## Installation

```
pkg> add https://github.com/Roger-luo/LatticeSites.jl.git
```

## Intro

This package provides `Sites` type, it defines the configuration of a lattice,
which can be used as indices for objects defined on lattices.

Binary configuration label is provided as:

- `Bit`,  refers to `0`/`1`
- `Spin`, refers to `-1`/`+1`
- `Half`, refers to `-0.5`/`+0.5`

`Sites` implemented **Array Interface**, you can use most of the function for arrays.

```julia
julia> rand(Bit, 2, 2)
2×2 Sites{Bit,Float64,2}:
 0.0  1.0
 1.0  0.0
```

The default type of elements in `Sites` are defined by those tags

```julia
julia> eltype(Bit)
Float64
```
You can also convert it to integers

```julia
julia> a = rand(Bit, 2, 2)
2×2 Sites{Bit,Float64,2}:
 0.0  0.0
 1.0  1.0

julia> convert(Int, a)
10
```

We use the convention that the first index `a[1]` take the first digit position
during the convention, which is opposite to natural notation `0b0101`, where the last
digit in bit string take the first position.

In short

`0b011` is equivalent to `Bit[1, 1, 0]`


## License

Apache License 2.0
