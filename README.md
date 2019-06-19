
<!-- README.md is generated from README.Rmd. Please edit that file -->

# panoply <img src="media/panoply_hex.png" width = 167 align="right"/>

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

A panoply of [camkay](https://github.com/camkay)’s miscellaneous
functions: `column_find`, `column_alpha`, `column_combine`, `scuttle`,
`spround`, `perble`, `lenique`, `pasterisk`, and `paste_paren`.
`scuttle` was created in collaboration with
[AshLynnMiller](https://github.com/AshLynnMiller).

## Installation

The development version of `panoply` can be installed from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("camkay/panoply")
```

## Examples

### column\_find

`column_find` is a function for quickly identifying columns of a data
frame that match a `pattern` specified through a string. The default
behaviour is to return a logical vector, indicating the columns that
match the `pattern`. Using the `return` argument, users can request that
a vector of column numbers (“numeric”) or column names (“character”) be
returned. Users can also request that a data frame with only those
columns be returned (“data.frame”). `column_find` can interpret [regular
expressions](https://en.wikipedia.org/wiki/Regular_expression).

``` r
# look at example data
data_example
#>   scale1_item1 scale1_item2 scale1_item3 scale2_item1 scale2_item2
#> 1            6            7            8            9            7
#> 2            1            2            1            9            8
#> 3            3            4            5            9            7
#> 4            4            5            4            8            9
#> 5            5            4            4            4            5
#> 6            9            8            9            2            1
#> 7            9            9            8            2            2

# return a logical vector of the columns that match the pattern
column_find(pattern = "scale1", return = "logical", data = data_example)
#> [1]  TRUE  TRUE  TRUE FALSE FALSE

# return a numeric vector of the columns that match the pattern
column_find(pattern = "scale1", return = "numeric", data = data_example)
#> [1] 1 2 3

# return a character vector of the columns that match the pattern
column_find(pattern = "scale1", return = "character", data = data_example)
#> [1] "scale1_item1" "scale1_item2" "scale1_item3"

# return a data frame of the columns that match the pattern
column_find(pattern = "scale1", return = "data.frame", data = data_example)
#>   scale1_item1 scale1_item2 scale1_item3
#> 1            6            7            8
#> 2            1            2            1
#> 3            3            4            5
#> 4            4            5            4
#> 5            5            4            4
#> 6            9            8            9
#> 7            9            9            8

# return a logical vector using a regular expression
column_find(pattern = "2$", return = "logical", data = data_example)
#> [1] FALSE  TRUE FALSE FALSE  TRUE
```

### column\_alpha

`column_alpha` estimates Cronbach’s Alpha–an indicator of internal
consistency–using only columns that have names that match a `pattern`.
The analysis relies on `psych::alpha`. If the `full` argument is `TRUE`,
the full results of the reliability analysis produced by the `psych`
package is returned. If `FALSE`, only the raw alpha value is returned.
In both cases, a message is generated informing the users what columns
were used to calculate the alpha value.

``` r
# look at example data
data_example
#>   scale1_item1 scale1_item2 scale1_item3 scale2_item1 scale2_item2
#> 1            6            7            8            9            7
#> 2            1            2            1            9            8
#> 3            3            4            5            9            7
#> 4            4            5            4            8            9
#> 5            5            4            4            4            5
#> 6            9            8            9            2            1
#> 7            9            9            8            2            2

# return the full reliability analysis
column_alpha(pattern = "scale1", full = TRUE, data = data_example)
#> Cronbach's Alpha was calculated using 3 columns: scale1_item1, scale1_item2, scale1_item3.
#> 
#> Reliability analysis   
#> Call: psych::alpha(x = data_found, na.rm = na.rm, warnings = FALSE)
#> 
#>   raw_alpha std.alpha G6(smc) average_r S/N   ase mean  sd median_r
#>       0.97      0.98    0.97      0.93  43 0.016  5.5 2.7     0.94
#> 
#>  lower alpha upper     95% confidence boundaries
#> 0.94 0.97 1.01 
#> 
#>  Reliability if an item is dropped:
#>              raw_alpha std.alpha G6(smc) average_r S/N alpha se var.r
#> scale1_item1      0.96      0.97    0.94      0.94  31    0.025    NA
#> scale1_item2      0.95      0.95    0.91      0.91  20    0.036    NA
#> scale1_item3      0.97      0.98    0.95      0.95  42    0.020    NA
#>              med.r
#> scale1_item1  0.94
#> scale1_item2  0.91
#> scale1_item3  0.95
#> 
#>  Item statistics 
#>              n raw.r std.r r.cor r.drop mean  sd
#> scale1_item1 7  0.98  0.98  0.96   0.94  5.3 3.0
#> scale1_item2 7  0.99  0.99  0.98   0.97  5.6 2.5
#> scale1_item3 7  0.97  0.97  0.95   0.93  5.6 2.9
#> 
#> Non missing response frequency for each item
#>                 1    2    3    4    5    6    7    8    9 miss
#> scale1_item1 0.14 0.00 0.14 0.14 0.14 0.14 0.00 0.00 0.29    0
#> scale1_item2 0.00 0.14 0.00 0.29 0.14 0.00 0.14 0.14 0.14    0
#> scale1_item3 0.14 0.00 0.00 0.29 0.14 0.00 0.00 0.29 0.14    0

# return only the raw Cronbach's Alpha
column_alpha(pattern = "scale1", full = FALSE, data = data_example)
#> Cronbach's Alpha was calculated using 3 columns: scale1_item1, scale1_item2, scale1_item3.
#> [1] 0.9740398
```

### column\_alpha

`column_alpha` estimates Cronbach’s Alpha–an indicator of internal
consistency–using only columns that have names that match a `pattern`.
The analysis relies on `psych::alpha`. If the `full` argument is `TRUE`,
the full results of the reliability analysis produced by the `psych`
package is returned. If `FALSE`, only the raw alpha value is returned.
In both cases, a message is generated informing the users what columns
were used to calculate the alpha value.

``` r
# look at example data
data_example
#>   scale1_item1 scale1_item2 scale1_item3 scale2_item1 scale2_item2
#> 1            6            7            8            9            7
#> 2            1            2            1            9            8
#> 3            3            4            5            9            7
#> 4            4            5            4            8            9
#> 5            5            4            4            4            5
#> 6            9            8            9            2            1
#> 7            9            9            8            2            2

# return the full reliability analysis
column_alpha(pattern = "scale1", full = TRUE, data = data_example)
#> Cronbach's Alpha was calculated using 3 columns: scale1_item1, scale1_item2, scale1_item3.
#> 
#> Reliability analysis   
#> Call: psych::alpha(x = data_found, na.rm = na.rm, warnings = FALSE)
#> 
#>   raw_alpha std.alpha G6(smc) average_r S/N   ase mean  sd median_r
#>       0.97      0.98    0.97      0.93  43 0.016  5.5 2.7     0.94
#> 
#>  lower alpha upper     95% confidence boundaries
#> 0.94 0.97 1.01 
#> 
#>  Reliability if an item is dropped:
#>              raw_alpha std.alpha G6(smc) average_r S/N alpha se var.r
#> scale1_item1      0.96      0.97    0.94      0.94  31    0.025    NA
#> scale1_item2      0.95      0.95    0.91      0.91  20    0.036    NA
#> scale1_item3      0.97      0.98    0.95      0.95  42    0.020    NA
#>              med.r
#> scale1_item1  0.94
#> scale1_item2  0.91
#> scale1_item3  0.95
#> 
#>  Item statistics 
#>              n raw.r std.r r.cor r.drop mean  sd
#> scale1_item1 7  0.98  0.98  0.96   0.94  5.3 3.0
#> scale1_item2 7  0.99  0.99  0.98   0.97  5.6 2.5
#> scale1_item3 7  0.97  0.97  0.95   0.93  5.6 2.9
#> 
#> Non missing response frequency for each item
#>                 1    2    3    4    5    6    7    8    9 miss
#> scale1_item1 0.14 0.00 0.14 0.14 0.14 0.14 0.00 0.00 0.29    0
#> scale1_item2 0.00 0.14 0.00 0.29 0.14 0.00 0.14 0.14 0.14    0
#> scale1_item3 0.14 0.00 0.00 0.29 0.14 0.00 0.00 0.29 0.14    0

# return only the raw Cronbach's Alpha
column_alpha(pattern = "scale1", full = FALSE, data = data_example)
#> Cronbach's Alpha was calculated using 3 columns: scale1_item1, scale1_item2, scale1_item3.
#> [1] 0.9740398
```
