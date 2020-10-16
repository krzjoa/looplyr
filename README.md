
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
library(dplyr)
#> 
#> Dołączanie pakietu: 'dplyr'
#> Następujące obiekty zostały zakryte z 'package:stats':
#> 
#>     filter, lag
#> Następujące obiekty zostały zakryte z 'package:base':
#> 
#>     intersect, setdiff, setequal, union
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
library(glue)
#> 
#> Dołączanie pakietu: 'glue'
#> Następujący obiekt został zakryty z 'package:dplyr':
#> 
#>     collapse
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
