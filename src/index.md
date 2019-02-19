class: middle, centre
# Open source tools for working with data

---

# Introduction

Open source software development for research:

oqyxqpgencpyomnbqjdjgqzxonpncpwlplhwvpihdfdpmvqxhw
- Efficient format for tabular data
oqyxqpgencpyomnbqjdjgqzxonpncpwlplhwvpihdfdpmvqxhw
- Metaprogramming tools for tabular data manipulations
oqyxqpgencpyomnbqjdjgqzxonpncpwlplhwvpihdfdpmvqxhw
- Plotting facility for tabular data (esp. grouped data)
oqyxqpgencpyomnbqjdjgqzxonpncpwlplhwvpihdfdpmvqxhw
- Custom array storage type to incorporate photometry or recordings in tables
oqyxqpgencpyomnbqjdjgqzxonpncpwlplhwvpihdfdpmvqxhw
- Toolkit to build web apps and specialized widgets for table manipulations

---

# Background: the Julia programming language
oqyxqpgencpyomnbqjdjgqzxonpncpwlplhwvpihdfdpmvqxhw
- JIT compiled language: type stable code runs at C-like speed
oqyxqpgencpyomnbqjdjgqzxonpncpwlplhwvpihdfdpmvqxhw
- rich type system allows for fast custom data structures
oqyxqpgencpyomnbqjdjgqzxonpncpwlplhwvpihdfdpmvqxhw
- multiple dispatch makes custom data structures easy to use
oqyxqpgencpyomnbqjdjgqzxonpncpwlplhwvpihdfdpmvqxhw
- metaprogramming

---

# StructArrays: flexibly switching from row-based to column-based

```@example 1
using StructArrays # hide
s = StructArray(a=1:3, b=["x", "y", "z"])
s[1]
```

```@example 1
s.a
```

```@example 1
map(row -> exp(row.a), s)
```

---

# JuliaDB

```@example 2
using JuliaDBMeta, Statistics # hide
iris = loadtable("/home/pietro/Data/examples/iris.csv")
```


--- 

# JuliaDB: working with columns

The package JuliaDBMeta provides a set of macros to work on tables (implemented under the hood as StructArrays). It implements normal tabular data operations (map, filter, join, groupby, etc...) but uses metaprogramming to allow the user to use symbols as if they were columns:

```@example 2
@with iris mean(:SepalLength) / mean(:SepalWidth)
```

---

# JuliaDB: working with rows

```@example 2
@apply iris begin
    @transform (Ratio = :SepalLength / :SepalWidth, Large = :PetalWidth > 2)
    @filter :Ratio > 2 && :Species != "versicolor"
end
```

---

# Adding neural data to a table: ShiftedArrays

While working with tables is obviously useful for behavioral data, it is less clear how neural data fits into the picture.

oqyxqpgencpyomnbqjdjgqzxonpncpwlplhwvpihdfdpmvqxhw

The package ShiftedArrays addresses this issue by creating a custom array type which is a normal array with a shift:

oqyxqpgencpyomnbqjdjgqzxonpncpwlplhwvpihdfdpmvqxhw

```@example 3
using ShiftedArrays, Statistics #hide
v = rand(10)
lead(v, 3)
```

---

# Adding neural data to a table: ShiftedArrays

The underlying data is shared, so creating a `ShiftedArray` is very cheap:

```@example 3
using BenchmarkTools # hide
v = rand(1_000_000)
@benchmark lead($v, 100)
```

---

# Adding neural data to a table: ShiftedArrays

A new column can be added by simply putting shifted copies of the recordings:

```@example 3
photometry = rand(100)
timestamps = [12, 23, 48, 97]
shiftedvecs = [lead(photometry, time) for time in timestamps]
ShiftedArrays.to_array(shiftedvecs, -5:5)
```

---

# Adding neural data to a table: ShiftedArrays

ShiftedArrays also provides utility function to reduce the data:

```@example 3
reduce_vec(mean, shiftedvecs, -5:5)
```

---

