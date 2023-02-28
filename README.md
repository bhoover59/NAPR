<p align = "center">
![NAPR with name](https://user-images.githubusercontent.com/77543359/221993432-913307d5-5aba-4ddb-8c62-4e85a415a3ca.PNG)
</p>
# Nitrous Acid Program in R (NAPR)

# About Me
NAPR is a  tool to predict steady state [HONO] and the unknown source. Calculates reaction rates. 
Created by Bode Hoover at IU Bloomington.
## Installation
If you need to install devtools
```
install.packages("devtools")
```
```
library(devtools)
```
Installing diurnals package
```
devtools::install_github("bhoover59/NAPR")
```
Or if that doesn't work
```
remotes::install_github("bhoover59/NAPR")
```
To remove the package go to Packages in RStudio and hit X on right side. If that doesn't work, try this
```
remove.packages("NAPR")
```
Or if that doesn't work
```
unloadNamespace("NAPR")
```

## core()
1. Inputs
   - df: data frame with field campaign data
   - TimeColumn: name of column with times. Can be any string format. Edit char_to_time function if additional formats needed
2. Outputs:
   - diurnal average
   - diurnal median
   - standard deviation for each bin
   - count for each bin
   - **DOES NOT CALCULATE SEM but that can easily be done by SEM = sd / sqrt(count)**
```
df <- Diurnal(df = df_name, TimeColumn = time_column_name)
```

## Future work:
   - Make RShiny app for UI
     -  Drop down menu to select what to plot
     -  Numeric inputs for inital conditions
     -  TUV model incorporation to make Jcorr
