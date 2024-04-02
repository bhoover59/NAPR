<p align = "center">
<img width = "541" alt="NAPR" src = "https://user-images.githubusercontent.com/77543359/221993432-913307d5-5aba-4ddb-8c62-4e85a415a3ca.PNG">
</p>

# Nitrous Acid Program in R (NAP-R)
# About Me
NAPR is a tool to calculate contributions of reaction mechanisms, predict [HONO], and estimate the unknown reaction rate based on observed NO<sub>x</sub>, JNO<sub>2</sub>, and OH but an OH estimation option is available. Created by Bode Hoover at IU Bloomington (bodehoov@iu.edu).

## Installation and Dependencies
All necessary packages should be installed after running the load_packages() function in the core.R file. If you need still to install devtools,
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

## Run the model
You will need to edit the core.R file to run the model with your field campaign data. Currently, the data must be a 24 hour diurnal which can be achieved using the diurnals package above. Additionally, the get_initial.R must be edited to adjust the initial conditions. 

## Diurnal average
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
   - Add diurnal average option for field campaign data instead of doing separately
