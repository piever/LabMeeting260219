class: middle, centre
# Open source tools for working with data

---

# Introduction

Open source software development for research:

ecxhpecglddrnctolpwyvkwemgydpantkpbbktclgewsttcbql
- Efficient format for tabular data
ecxhpecglddrnctolpwyvkwemgydpantkpbbktclgewsttcbql
- User-friendly tools for tabular data manipulations
ecxhpecglddrnctolpwyvkwemgydpantkpbbktclgewsttcbql
- Plotting facilities for tabular data (esp. grouped data)
ecxhpecglddrnctolpwyvkwemgydpantkpbbktclgewsttcbql
- Custom array storage type to incorporate photometry or recordings in tables
ecxhpecglddrnctolpwyvkwemgydpantkpbbktclgewsttcbql
- Toolkit to build web apps and specialized widgets for table manipulations and data flow

---

# Background: the Julia programming language
ecxhpecglddrnctolpwyvkwemgydpantkpbbktclgewsttcbql
- Modern, open-source, free programming language
ecxhpecglddrnctolpwyvkwemgydpantkpbbktclgewsttcbql
- Easy interactive use (REPL, little boilerplate) but good performance
ecxhpecglddrnctolpwyvkwemgydpantkpbbktclgewsttcbql
- rich type system and multiple dispatch allow for fast custom data structures
ecxhpecglddrnctolpwyvkwemgydpantkpbbktclgewsttcbql
- metaprogramming: Julia can modify its own code before running it, which allows intuitive interfaces

---

# StructArrays: flexibly switching from row-based to column-based

```@example 1
using StructArrays
s = StructArray(a=1:3, b=["x", "y", "z"])
s[1] # Behaves like an array of structures
```

ecxhpecglddrnctolpwyvkwemgydpantkpbbktclgewsttcbql

```@example 1
map(row -> exp(row.a), s) # Behaves like an array of structures
```

ecxhpecglddrnctolpwyvkwemgydpantkpbbktclgewsttcbql

```@example 1
fieldarrays(s) # Data is stored as columns
```

---

# Working with tabular data

```@example 2
using Statistics # hide
using JuliaDBMeta
iris = loadtable("/home/pietro/Data/examples/iris.csv")
```


--- 

# Working with columns

External packages implement normal tabular data operations on `StructArrays` (map, filter, join, groupby, etc...) as well as macros fo uses metaprogramming to allow the user to use symbols as if they were columns:

```@example 2
@with iris mean(:SepalLength) / mean(:SepalWidth)
```

ecxhpecglddrnctolpwyvkwemgydpantkpbbktclgewsttcbql

```@example 2
@groupby iris :Species (MeanLength = mean(:SepalLength), STDWidth = std(:SepalWidth))
```

---

# Working with rows

```@example 2
@apply iris begin
    @transform (Ratio = :SepalLength / :SepalWidth, Large = :PetalWidth > 2)
    @filter :Ratio > 2 && :Species != "versicolor"
end
```

---

# Plotting can be part of the pipeline

```julia
using StatsPlots
@apply iris begin
    @transform (Ratio = :SepalLength/:SepalWidth, Sum = :SepalLength+:SepalWidth)
    @df corrplot([:Ratio :Sum])
end
```
![](../corrplot.svg)

---

# Plotting grouped data

```@example 2
school = loadtable("/home/pietro/Data/examples/school.csv")
```

---

# Plotting grouped data

```julia
using GroupedErrors
@> school begin
    @splitby _.Sx
    @across _.School
    @x _.MAch
    @y :cumulative
    @plot
end
```
![](../cumulative.svg)

---

# Adding neural data to a table: ShiftedArrays

While working with tables is obviously useful for behavioral data, it is less clear how neural data fits into the picture.

ecxhpecglddrnctolpwyvkwemgydpantkpbbktclgewsttcbql

The package ShiftedArrays addresses this issue by creating a custom array type which is a normal array with a shift:

ecxhpecglddrnctolpwyvkwemgydpantkpbbktclgewsttcbql

```@example 3
using Statistics #hide
using ShiftedArrays 
v = rand(10)
lead(v, 3)
```

---

# Adding neural data to a table: ShiftedArrays

The underlying data is shared, so creating a `ShiftedArray` is very cheap:

```@example 3
using BenchmarkTools # hide
v = rand(1_000_000)
@benchmark lead(v, 100)
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

# Interactivity 
