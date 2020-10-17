
<!-- README.md is generated from README.Rmd. Please edit that file -->

# looplyr

<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/krzjoa/looplyr.svg?branch=master)](https://travis-ci.com/krzjoa/looplyr)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/krzjoa/looplyr?branch=master&svg=true)](https://ci.appveyor.com/project/krzjoa/looplyr)
<!-- badges: end -->

> Loop Verbs For Grammar of Data Manipulation

## Installation

``` r
# install.packages("devtools")
devtools::install_github("krzjoa/looplyr")
```

## Example

`looplyr` provides easy-to-use shortcuts to apply `mutate`/`summarise`
in loop and and loop operator to process multiple data.frame-like
objects using one `dplyr`/`magrittr` pipe wrapped with curly brackets.

### `loop_mutate`

``` r
suppressMessages(library(dplyr))
suppressMessages(library(glue))
library(looplyr)

cars %>%
   loop_mutate(
     2:4, paste0("speed.", .x) := speed ** .x
   ) %>%
   head(5)
#>   speed dist speed.2 speed.3 speed.4
#> 1     4    2      16      64     256
#> 2     4   10      16      64     256
#> 3     7    4      49     343    2401
#> 4     7   22      49     343    2401
#> 5     8   16      64     512    4096
```

### `loop_summarise`

``` r
quantiles <- c(0.25, 0.50, 0.75)
iris %>%
  group_by(Species) %>%
  loop_summarise(
     quantiles,
     glue("Petal.Length.{.x}") := quantile(Petal.Length, .x),
     glue("Petal.Width.{.x}") := quantile(Petal.Width, .x)
   )
#> # A tibble: 3 x 7
#>   Species Petal.Length.0.… Petal.Width.0.25 Petal.Length.0.5 Petal.Width.0.5
#>   <fct>              <dbl>            <dbl>            <dbl>           <dbl>
#> 1 setosa               1.4              0.2             1.5              0.2
#> 2 versic…              4                1.2             4.35             1.3
#> 3 virgin…              5.1              1.8             5.55             2  
#> # … with 2 more variables: Petal.Length.0.75 <dbl>, Petal.Width.0.75 <dbl>
```

### `%m>%`/`%f>%`

``` r
list(cars, mtcars) %m>% {
   mutate(idx = 1:n())
}
#> [[1]]
#>    speed dist idx
#> 1      4    2   1
#> 2      4   10   2
#> 3      7    4   3
#> 4      7   22   4
#> 5      8   16   5
#> 6      9   10   6
#> 7     10   18   7
#> 8     10   26   8
#> 9     10   34   9
#> 10    11   17  10
#> 11    11   28  11
#> 12    12   14  12
#> 13    12   20  13
#> 14    12   24  14
#> 15    12   28  15
#> 16    13   26  16
#> 17    13   34  17
#> 18    13   34  18
#> 19    13   46  19
#> 20    14   26  20
#> 21    14   36  21
#> 22    14   60  22
#> 23    14   80  23
#> 24    15   20  24
#> 25    15   26  25
#> 26    15   54  26
#> 27    16   32  27
#> 28    16   40  28
#> 29    17   32  29
#> 30    17   40  30
#> 31    17   50  31
#> 32    18   42  32
#> 33    18   56  33
#> 34    18   76  34
#> 35    18   84  35
#> 36    19   36  36
#> 37    19   46  37
#> 38    19   68  38
#> 39    20   32  39
#> 40    20   48  40
#> 41    20   52  41
#> 42    20   56  42
#> 43    20   64  43
#> 44    22   66  44
#> 45    23   54  45
#> 46    24   70  46
#> 47    24   92  47
#> 48    24   93  48
#> 49    24  120  49
#> 50    25   85  50
#> 
#> [[2]]
#>     mpg cyl  disp  hp drat    wt  qsec vs am gear carb idx
#> 1  21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4   1
#> 2  21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4   2
#> 3  22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1   3
#> 4  21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1   4
#> 5  18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2   5
#> 6  18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1   6
#> 7  14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4   7
#> 8  24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2   8
#> 9  22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2   9
#> 10 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4  10
#> 11 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4  11
#> 12 16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3  12
#> 13 17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3  13
#> 14 15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3  14
#> 15 10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4  15
#> 16 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4  16
#> 17 14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4  17
#> 18 32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1  18
#> 19 30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2  19
#> 20 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1  20
#> 21 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1  21
#> 22 15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2  22
#> 23 15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2  23
#> 24 13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4  24
#> 25 19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2  25
#> 26 27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1  26
#> 27 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2  27
#> 28 30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2  28
#> 29 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4  29
#> 30 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6  30
#> 31 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8  31
#> 32 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2  32
```
