
<!-- README.md is generated from README.Rmd. Please edit that file -->

# panoply <img src="tools/panoply_hex.png" width = 167 align="right"/>

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/camkay/panoply.svg?branch=master)](https://travis-ci.org/camkay/panoply)
[![Build
status](https://ci.appveyor.com/api/projects/status/63wlqbusgqetyx9u?svg=true)](https://ci.appveyor.com/project/camkay/panoply)
[![Codecov test
coverage](https://codecov.io/gh/camkay/panoply/branch/master/graph/badge.svg)](https://codecov.io/gh/camkay/panoply?branch=master)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

A panoply of miscellaneous functions: `column_find`, `column_alpha`,
`column_combine`, `capply`, `scuttle`, `spround`, `perble`, `lenique`,
`pasterisk`, `bolder`, `paste_paren`, `paste_ci`, `centre`, `mat_merge`,
`delta_rsq`, `delta_aic`, `delta_bic`, `group_compare`, `build_models`,
`text_format` (including `bold`, `bold_tex`, `italic`, and
`italic_tex`), and `dark` (including `dark_triad` and `dark_tetrad`).
`scuttle` was created in collaboration with
[AshLynnMiller](https://github.com/AshLynnMiller). A large debt of
gratitude is also owed to [datalorax](https://github.com/datalorax) and
his functional programming course. His instruction, course materials,
and feedback were instrumental in creating this package.

## Installation

The development version of `panoply` can be installed from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("camkay/panoply")
```

## Descriptions and Examples

### column\_find

`column_find` is a function for quickly identifying columns of a data
frame that match a `pattern` specified through a string. The default
behaviour is to return a logical vector, indicating the columns that
match the `pattern`. Using the `return` argument, users can request that
a vector of column numbers (“numeric”) or column names (“character”) be
returned. `invert` works for all return types, identifying or extracting
the columns of interest. Users can also request that a data frame with
only those columns be returned (“data.frame”). `column_find` can
interpret [regular
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

# return a data frame of the columns that DO NOT match the pattern
column_find(pattern = "scale1", 
            return  = "data.frame", 
            data    = data_example,
            invert  = FALSE)
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

# return the full reliability analysis for scale 1
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
#>              raw_alpha std.alpha G6(smc) average_r S/N alpha se var.r med.r
#> scale1_item1      0.96      0.97    0.94      0.94  31    0.025    NA  0.94
#> scale1_item2      0.95      0.95    0.91      0.91  20    0.036    NA  0.91
#> scale1_item3      0.97      0.98    0.95      0.95  42    0.020    NA  0.95
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

# return only the raw Cronbach's Alpha for scale 1
column_alpha(pattern = "scale1", full = FALSE, data = data_example)
#> Cronbach's Alpha was calculated using 3 columns: scale1_item1, scale1_item2, scale1_item3.
#> [1] 0.9740398
```

### column\_combine

`column_combine` creates a composite column using only columns in a data
frame that have names that match a `pattern`. The argument `fun`
specifies specifies what function should be used to create the composite
column. Averaging is the default.

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

# return a vector of rowwise means for scale 1
column_combine(pattern = "scale1", fun = mean, data = data_example)
#> A composite column was calculated using 3 columns: scale1_item1, scale1_item2, scale1_item3.
#> [1] 7.000000 1.333333 4.000000 4.333333 4.333333 8.666667 8.666667

# return a vector of rowwise sums for scale 1
column_combine(pattern = "scale1", fun = sum, data = data_example)
#> A composite column was calculated using 3 columns: scale1_item1, scale1_item2, scale1_item3.
#> [1] 21  4 12 13 13 26 26
```

### capply

`capply` is a wrapper of `apply` that allows the user to quickly apply a
function to every cell of a data frame.

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

# add 100 to every cell of data_example
capply(data_example, function(x) x + 100)
#>      scale1_item1 scale1_item2 scale1_item3 scale2_item1 scale2_item2
#> [1,]          106          107          108          109          107
#> [2,]          101          102          101          109          108
#> [3,]          103          104          105          109          107
#> [4,]          104          105          104          108          109
#> [5,]          105          104          104          104          105
#> [6,]          109          108          109          102          101
#> [7,]          109          109          108          102          102
```

### scuttle

`scuttle` turns a continuous (i.e., numeric) variable into a categorical
(i.e., character or factor) variable. Using the `split` argument, users
can specify whether they want a (1) quantile-split, (2) split at 1, 2,
or 3 standard deviations above or below the mean, (3) split at 1, 2, or
3 standard errors above or below the mean. Users can specify whether the
output should be a factor or a character using the `as.factor` argument.

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

# split scale1_item1 using a quantile-split method and return a factor
scuttle(column = data_example$scale1_item1, split = "quantile", as.factor = TRUE)
#> [1] Mid  Low  Low  Mid  Mid  High High
#> Levels: Low Mid High

# split scale1_item1 using a 1sd-split method and return a character vector
scuttle(column = data_example$scale1_item1, split = "sd1", as.factor = FALSE)
#> [1] "Mid"  "Low"  "Mid"  "Mid"  "Mid"  "High" "High"
```

### spround

`spround` rounds a number or a vector of numbers (using `round`) and
specifies knitted decimal places (using `sprintf`) all in one step.
Users can specify whether leading zeroes should be retained or not using
`leading0`.

``` r
# look at example numeric vector
num_example
#>  [1] 5.0000 1.0000 0.0000 0.5000 0.1000 0.0500 0.0100 0.0050 0.0010 0.0005

# round num_example to three decimal places and retain leading zeroes
spround(x = num_example, digits = 3, leading0 = TRUE)
#>  [1] "5.000" "1.000" "0.000" "0.500" "0.100" "0.050" "0.010" "0.005" "0.001"
#> [10] "0.000"

# round num_example to three decimal places and drop leading zeroes
spround(x = num_example, digits = 3, leading0 = FALSE)
#>  [1] "5.000" "1.000" ".000"  ".500"  ".100"  ".050"  ".010"  ".005"  ".001" 
#> [10] ".000"
```

### perble

`perble` extends `table` by including proportions and percentages. By
default the results are put into [tidy
format](https://en.wikipedia.org/wiki/Tidy_data). Results will be
returned as a numeric matrix if the `tidy` argument is set to `FALSE`.

``` r
# look at example character vector
char_example
#> [1] "cat"     "cat"     "dog"     "cat"     "dog"     "giraffe"

# produce the counts, proportions, and percentages and present the results in tidy format
perble(x = char_example, tidy = TRUE)
#>     group count proportion  percent
#> 1     cat     3  0.5000000 50.00000
#> 2     dog     2  0.3333333 33.33333
#> 3 giraffe     1  0.1666667 16.66667

# produce the counts, proportions, and percentages and present the results as a numeric matrix
perble(x = char_example, tidy = FALSE)
#>             cat        dog    giraffe
#> count       3.0  2.0000000  1.0000000
#> proportion  0.5  0.3333333  0.1666667
#> percent    50.0 33.3333333 16.6666667
```

### lenique

`lenique` is a very simple wrapper that calculates the length of unique
values in a vector in one step. It is identical to running
`length(unique(x))`.

``` r
# look at the example character vector
char_example
#> [1] "cat"     "cat"     "dog"     "cat"     "dog"     "giraffe"

# calculate the length of unique values in char_example
lenique(x = char_example)
#> [1] 3
```

### pasterisk

`pasterisk` takes a scalar or atomic vector of, for example, p-values
and returns a scalar or atomic vector of asterisks corresponding to
different significance levels. The argument `thresholds` can be used to
set the cut-off valuess for the different values. Any number of
thresholds can be set. By default, an asterisk (i.e., "\*") is used as
the `sig_symbol`, but any single character vector can be used.

``` r
# look at the example numeric vector
num_example
#>  [1] 5.0000 1.0000 0.0000 0.5000 0.1000 0.0500 0.0100 0.0050 0.0010 0.0005

# create a vector of asterisks using the default thresholds
pasterisk(p_vals = num_example, thresholds = c(0.05, 0.01, 0.001), sig_symbol = "*")
#>  [1] ""    ""    "***" ""    ""    ""    "*"   "**"  "**"  "***"

# create a vector of octothorps/hashtags/pound using the default thresholds
pasterisk(p_vals = num_example, thresholds = c(0.05, 0.01, 0.001), sig_symbol = "#")
#>  [1] ""    ""    "###" ""    ""    ""    "#"   "##"  "##"  "###"

# create a vector of asterisks using custom thresholds
pasterisk(p_vals = num_example, thresholds = c(0.10, 0.5), sig_symbol = "*")
#>  [1] ""   ""   "**" ""   "*"  "**" "**" "**" "**" "**"
```

### bolder

`bolder` takes a scalar or atomic vector of effect sizes and bolds
values that are equal to or larger than a specified size.

``` r
# look at the example numeric vector
num_example
#>  [1] 5.0000 1.0000 0.0000 0.5000 0.1000 0.0500 0.0100 0.0050 0.0010 0.0005

# bold values that are larger than .30
bolder(ef = num_example, threshold = .30)
#>  [1] "\\textbf{5}"   "\\textbf{1}"   "0"             "\\textbf{0.5}"
#>  [5] "0.1"           "0.05"          "0.01"          "0.005"        
#>  [9] "0.001"         "0.0005"

# bold values that are larger than 1.00
bolder(ef = num_example, threshold = 1.00)
#>  [1] "\\textbf{5}" "\\textbf{1}" "0"           "0.5"         "0.1"        
#>  [6] "0.05"        "0.01"        "0.005"       "0.001"       "0.0005"
```

### paste\_paren

`paste_paren` combines two numbers (e.g., 10.12 and 2.22) by wrapping
the latter in parentheses (e.g., 10.12 (2.22)). This function was made
to streamline the creation of tables that include cells formatted as
“mean(sd)”.

``` r
# combine two numbers
paste_paren(10.12, 2.22)
#> [1] "10.12 (2.22)"
```

### paste\_ci

`paste_ci` combines two numbers (e.g., .20 and .33) by wrapping them in
square brackets (e.g., \[.20, .33\]). This function was made to
streamline the creation of confidence interval values for outputting.

``` r
# combine two numbers
paste_ci(.20, .33)
#> [1] "[0.2, 0.33]"
```

### mat\_merge

`mat_merge` combines two matrices by drawing values from either below or
above the diagonal and placing them either below and above the diagonal.

``` r
# look at matrix a
mat_a
#>      [,1]     [,2]     [,3]     [,4]     [,5]   
#> [1,] "apple"  "apple"  "apple"  "apple"  "apple"
#> [2,] "orange" "apple"  "apple"  "apple"  "apple"
#> [3,] "orange" "orange" "apple"  "apple"  "apple"
#> [4,] "orange" "orange" "orange" "apple"  "apple"
#> [5,] "orange" "orange" "orange" "orange" "apple"

# look at matrix b
mat_b
#>      [,1]     [,2]     [,3]     [,4]     [,5]    
#> [1,] "banana" "banana" "banana" "banana" "banana"
#> [2,] "kiwi"   "banana" "banana" "banana" "banana"
#> [3,] "kiwi"   "kiwi"   "banana" "banana" "banana"
#> [4,] "kiwi"   "kiwi"   "kiwi"   "banana" "banana"
#> [5,] "kiwi"   "kiwi"   "kiwi"   "kiwi"   "banana"

# merge by drawing values from below the diagonal of both matrices
mat_merge(mat_a, 
          mat_b, 
          x_from = "lower", 
          y_from = "lower", 
          x_to   = "lower", 
          y_to   = "upper")
#>      [,1]     [,2]     [,3]     [,4]     [,5]  
#> [1,] "0"      "kiwi"   "kiwi"   "kiwi"   "kiwi"
#> [2,] "orange" "0"      "kiwi"   "kiwi"   "kiwi"
#> [3,] "orange" "orange" "0"      "kiwi"   "kiwi"
#> [4,] "orange" "orange" "orange" "0"      "kiwi"
#> [5,] "orange" "orange" "orange" "orange" "0"

# merge by drawing values from below the diagonal of mat_a and above the 
# diagonal of mat_b
mat_merge(mat_a, 
          mat_b, 
          x_from = "lower", 
          y_from = "upper", 
          x_to   = "lower", 
          y_to   = "upper")
#>      [,1]     [,2]     [,3]     [,4]     [,5]    
#> [1,] "0"      "banana" "banana" "banana" "banana"
#> [2,] "orange" "0"      "banana" "banana" "banana"
#> [3,] "orange" "orange" "0"      "banana" "banana"
#> [4,] "orange" "orange" "orange" "0"      "banana"
#> [5,] "orange" "orange" "orange" "orange" "0"

# identical to previous mat_merge but put the values into the opposite 
# quadrant of the matrix
mat_merge(mat_a, 
          mat_b, 
          x_from = "lower", 
          y_from = "upper", 
          x_to   = "upper", 
          y_to   = "lower")
#>      [,1]     [,2]     [,3]     [,4]     [,5]    
#> [1,] "0"      "orange" "orange" "orange" "orange"
#> [2,] "banana" "0"      "orange" "orange" "orange"
#> [3,] "banana" "banana" "0"      "orange" "orange"
#> [4,] "banana" "banana" "banana" "0"      "orange"
#> [5,] "banana" "banana" "banana" "banana" "0"
```

### centre (center)

`centre` (or `center`) centres (or centers) a numeric vector. It is
identical to running ‘scale(x, center = TRUE, scale = FALSE)’.

``` r
# look at num_example
num_example
#>  [1] 5.0000 1.0000 0.0000 0.5000 0.1000 0.0500 0.0100 0.0050 0.0010 0.0005

# centre num_example
centre(num_example)
#>           [,1]
#>  [1,]  4.33335
#>  [2,]  0.33335
#>  [3,] -0.66665
#>  [4,] -0.16665
#>  [5,] -0.56665
#>  [6,] -0.61665
#>  [7,] -0.65665
#>  [8,] -0.66165
#>  [9,] -0.66565
#> [10,] -0.66615
#> attr(,"scaled:center")
#> [1] 0.66665
```

### delta\_rsq, delta\_aic, and delta\_bic

`delta_rsq`, `delta_aic`, and `delta_bic` calculate the change to
R-Squared, AIC, and BIC across two or more models.

``` r
# calculate delta r-squared
delta_rsq(models = list(mod_a_example, mod_b_example, mod_c_example))
#>           model  delta_rsq
#> 1 mod_a_example         NA
#> 2 mod_b_example 0.07115238
#> 3 mod_c_example 0.23864225

# calculate delta adjusted r-squared
delta_rsq(models = list(mod_a_example, mod_b_example, mod_c_example),
          adjusted = TRUE)
#>           model delta_rsq_adj
#> 1 mod_a_example            NA
#> 2 mod_b_example    0.01073412
#> 3 mod_c_example    0.35286995

# calculate delta AIC
delta_aic(models = list(mod_a_example, mod_b_example, mod_c_example))
#>           model   delta_aic
#> 1 mod_a_example          NA
#> 2 mod_b_example   0.2395225
#> 3 mod_c_example -20.3696756

# calculate delta BIC
delta_bic(models = list(mod_a_example, mod_b_example, mod_c_example))
#>           model   delta_bic
#> 1 mod_a_example          NA
#> 2 mod_b_example   0.1854326
#> 3 mod_c_example -20.4237654
```

### group\_compare

`group_compare` creates a group comparison table. It (1) calculates an
overall mean and sd, as well as a mean and sd for each group, (2) runs a
two-samples t-test comparing both groups, and (3) calculates Cohen’s d.

``` r
# look at example data
data_example_2
#>    group mach narc psyc
#> 1      A   NA    2    3
#> 2      A    2    4    4
#> 3      B  300  500 1800
#> 4      B  200  700 2000
#> 5      A    3   10    5
#> 6      A   NA    2    3
#> 7      A    2    4    4
#> 8      B  300  500 1800
#> 9      B  200  700 2000
#> 10     A    3   10    5

# create group comparison table from example data
group_compare(data_example_2, cols = c("mach", "narc"), split = "group")
#>   term overall_m overall_sd overall_n group1_m group1_sd group1_n group2_m
#> 1 mach    126.25   137.5882         8 2.500000 0.5773503        4      250
#> 2 narc    243.20   314.2500        10 5.333333 3.7237973        6      600
#>   group2_sd group2_n          t       df           p         d
#> 1  57.73503        4  -8.573223 3.000600 0.003332988 -6.062184
#> 2 115.47005        4 -10.296360 3.004161 0.001942013 -6.646272

# create group comparison table, rounding and collapsing
group_compare(data_example_2, 
              cols = c("mach", "narc"), 
              split = "group",
              spround = TRUE,
              collapse = TRUE)
#>   term     overall_msd overall_n  group1_msd group1_n      group2_msd group2_n
#> 1 mach 126.25 (137.59)      8.00 2.50 (0.58)     4.00  250.00 (57.74)     4.00
#> 2 narc 243.20 (314.25)     10.00 5.33 (3.72)     6.00 600.00 (115.47)     4.00
#>        t df    p     d
#> 1  -8.57  3 .003 -6.06
#> 2 -10.30  3 .002 -6.65
```

### zo

`zo` creates a zero-order correlation table. It allows you to specify a
grouping variable (`split`) and calculates a different correlation
matrix above and below the diagonal.

``` r
# look at example data
data_example_3
#>    group mach narc psyc
#> 1      A    1   10   -1
#> 2      B    2   20   -7
#> 3      A    3   35   -1
#> 4      A    4   50   -1
#> 5      B    5   65   -3
#> 6      B    6   71   -4
#> 7      A    7   80    1
#> 8      B    8   96   -9
#> 9      B    9   99   -9
#> 10     A   10   90   -1

# create a zero-order correlation table
zo(data_example_3, cols = c("mach", "narc", "psyc"), split = "group")
#> A is below the diagonal. B is above the diagonal.
#>            1.    2.   3.
#> 1. mach     - .99** -.46
#> 2. narc .97**     - -.36
#> 3. psyc   .32   .46    -

# create a zero-order correlation table for manipulation
zo(data_example_3, cols = c("mach", "narc", "psyc"), split = "group", pasterisk = FALSE)
#> A is below the diagonal. B is above the diagonal.
#>         mach_r narc_r psyc_r mach_p narc_p psyc_p
#> 1. mach   1.00    .99   -.46   .000   .002   .438
#> 2. narc    .97   1.00   -.36   .005   .000   .553
#> 3. psyc    .32    .46   1.00   .604   .434   .000
```

### build\_models

`build_models` takes an outcome string (i.e., `outcome`) and a list of
predictor strings (i.e., `predictors`) and builds a set of models.

``` r
# create a set of linear models
build_models(outcome = "y", predictors = list("1", "x1", "x2"))
#> [1] "y ~ 1"           "y ~ 1 + x1"      "y ~ 1 + x1 + x2"

# create a set of linear models with predictors added simultaneously
build_models(outcome = "y", predictors = list("1", "x1", c("z1", "z2")))
#> [1] "y ~ 1"                "y ~ 1 + x1"           "y ~ 1 + x1 + z1 + z2"

# create a set of linear models with interactions
build_models(outcome = "y", predictors = list("1", 
                                              "x1", 
                                              c("z1", "z2"),
                                              c("x1 * z1", "x1 * z2")))
#> [1] "y ~ 1"                                   
#> [2] "y ~ 1 + x1"                              
#> [3] "y ~ 1 + x1 + z1 + z2"                    
#> [4] "y ~ 1 + x1 + z1 + z2 + x1 * z1 + x1 * z2"

# create a set of linear mixed-effects models
build_models(outcome = "y", predictors = list("1 + (1 |id)", 
                                              "x1", 
                                              "x2"))
#> [1] "y ~ 1 + (1 |id)"           "y ~ 1 + (1 |id) + x1"     
#> [3] "y ~ 1 + (1 |id) + x1 + x2"
```

### text\_format

`text_format` formats strings as bold or italicized using markdown or
LaTeX syntax. `bold(x)` is a shortcut for `text_format(x, format =
"bold", latex = FALSE)` and `italic(x)` is a shortcut for
`text_format(x, format = "italic", latex = FALSE)`. `bold_tex(x)` is a
shortcut for `text_format(x, format = "bold", latex = TRUE)` and
`italic_tex(x)` is a shortcut for `text_format(x, format = "italic",
latex = TRUE)`.

``` r
# look at example strings
char_example
#> [1] "cat"     "cat"     "dog"     "cat"     "dog"     "giraffe"

# italicize strings using markdown formatting
text_format(char_example, format = "italic", latex = FALSE) #or 
#> [1] "*cat*"     "*cat*"     "*dog*"     "*cat*"     "*dog*"     "*giraffe*"
italic(char_example)
#> [1] "*cat*"     "*cat*"     "*dog*"     "*cat*"     "*dog*"     "*giraffe*"

# italicize strings using latex formatting
text_format(char_example, format = "italic", latex = TRUE) #or 
#> [1] "\\textit{cat}"     "\\textit{cat}"     "\\textit{dog}"    
#> [4] "\\textit{cat}"     "\\textit{dog}"     "\\textit{giraffe}"
italic_tex(char_example)
#> [1] "\\textit{cat}"     "\\textit{cat}"     "\\textit{dog}"    
#> [4] "\\textit{cat}"     "\\textit{dog}"     "\\textit{giraffe}"

# bold strings using markdown formatting
text_format(char_example, format = "bold", latex = FALSE) #or 
#> [1] "**cat**"     "**cat**"     "**dog**"     "**cat**"     "**dog**"    
#> [6] "**giraffe**"
bold(char_example)
#> [1] "**cat**"     "**cat**"     "**dog**"     "**cat**"     "**dog**"    
#> [6] "**giraffe**"

# bold strings using latex formatting
text_format(char_example, format = "bold", latex = TRUE) #or 
#> [1] "\\textbf{cat}"     "\\textbf{cat}"     "\\textbf{dog}"    
#> [4] "\\textbf{cat}"     "\\textbf{dog}"     "\\textbf{giraffe}"
bold_tex(char_example)
#> [1] "\\textbf{cat}"     "\\textbf{cat}"     "\\textbf{dog}"    
#> [4] "\\textbf{cat}"     "\\textbf{dog}"     "\\textbf{giraffe}"

# super- and subscript strings using markdown formatting
text_format(char_example, format = "super", latex = FALSE)
#> [1] "^cat^"     "^cat^"     "^dog^"     "^cat^"     "^dog^"     "^giraffe^"
text_format(char_example, format = "sub", latex = FALSE)
#> [1] "~cat~"     "~cat~"     "~dog~"     "~cat~"     "~dog~"     "~giraffe~"

# super- and subscript strings using latex formatting
text_format(char_example, format = "super", latex = TRUE)
#> [1] "\\textsuperscript{cat}"     "\\textsuperscript{cat}"    
#> [3] "\\textsuperscript{dog}"     "\\textsuperscript{cat}"    
#> [5] "\\textsuperscript{dog}"     "\\textsuperscript{giraffe}"
text_format(char_example, format = "sub", latex = TRUE)
#> [1] "\\textsubscript{cat}"     "\\textsubscript{cat}"    
#> [3] "\\textsubscript{dog}"     "\\textsubscript{cat}"    
#> [5] "\\textsubscript{dog}"     "\\textsubscript{giraffe}"
```

### dark

`dark` returns a vector of aversive personality trait names (e.g., the
Dark Triad or Dark Tetrad traits).

``` r
# return the dark triad traits
dark("triad")
#> [1] "Machiavellianism" "Narcissism"       "Psychopathy"

# you can also use the dark_triad shortcut
dark_triad()
#> [1] "Machiavellianism" "Narcissism"       "Psychopathy"

# return the dark tetrad traits
dark("tetrad")
#> [1] "Machiavellianism" "Narcissism"       "Psychopathy"      "Sadism"

# you can also use the dark_tetrad shortcut
dark_tetrad()
#> [1] "Machiavellianism" "Narcissism"       "Psychopathy"      "Sadism"

# if you want shortened names, you can set shorten to `TRUE`
dark("triad", shorten = TRUE)
#> [1] "Mach" "Narc" "Psyc"

# and if you want it to be shortened to some other length, `shorten_length`
dark("triad", shorten = TRUE, shorten_length = 3)
#> [1] "Mac" "Nar" "Psy"

# maybe you want it in italics...
dark("triad", format = "italic")
#> [1] "*Machiavellianism*" "*Narcissism*"       "*Psychopathy*"

# ...or bold
dark("triad", format = "bold")
#> [1] "**Machiavellianism**" "**Narcissism**"       "**Psychopathy**"

# ...or in latex italics
dark("triad", format = "italic", latex = TRUE)
#> [1] "\\textit{Machiavellianism}" "\\textit{Narcissism}"      
#> [3] "\\textit{Psychopathy}"
```
