#### Version: 2020.04.07, Tomasz Jetka ####
#### Calculation of Channel Capacity directly from experimental data files ####

#### Run two lines (install.packages(xxx)) below only once ####
# After that put a "#" in front of two lines below #
install.packages("SLEMI")
install.packages("readxl")


## In general it is assumed that the data is given as excel files provided 
## in a single folder, which all have exactly the same structure 
## i.e. there is only one sheet in the file with data 
## and columns of the data.frame which are consistent in all files
## The user needs to set:
## - the name of the folder with data
## - the name of the column with input (concentration of the stimulus)
## - the name of the column with output (concentration of the response)
## - (optionally) the name of the column with the 'confounding variable'
## It is recommended that values of input and output includes only numbers
## (However, numbers should be extracted if the format of data is different)
## Follow instructions below, and read any errors or warnings that will 
## come out in the console.

## In case of any problem, issues or questions, please contact:
## Tomasz Jetka, t.jetka@gmail.com


#### PARAMETERS TO SET ####
# (put below a directory to a path with data folders) #
# Important: do not use "\" - use "/" instead - sorry for inconvenience #
working_directory="C:/Users/ThinkPad_TJ/Dropbox/Projects/Magdeburg_CC/"
working_directory="D:/CloudDrives/DropBox/Dropbox/Projects/200407_Magdeburg_CC/"

# put below the name of the folder with data
data_folder="data_example"

# put below the name of the column with input/signal.
# It is assumed that the values in the column include number
# in the format [xxx].[xxx] - it will be detected.
# For example, "10.50 ng 30 min" will be detected as 10.50,
# but it would be better to have only the number.
signal_column="Conc" # put input name here

# put below the name of the column with output/response
# It is assumed that the values in the column include number
# in the format [xxx].[xxx] - it will be detected.
response_column="pSTAT3" # put output name here

# If applicable, put here the name of confounding variable
# If simple mode is needed, put here "NULL"
# for example, try to change to "STAT3"
addVar_column=NULL # put name of additional/confounding variable here



#### Main Analysis ####
setwd(working_directory)
source("aux_functions.R")


calculate_capacity(data_folder,
                   signal_column,response_column,addVar_column)


# The output will be in folder "output/" with unique name
# Please verify the concentration names detected in the plot
# and the range of output variable in the box-plot.
# The plots are only generic ones - some visual glitches can happen

# If you require a more comprehensive calculation of channel capacity with
# a proper statistical assessment (p-values of bootstrap and cross-validation)
#  uncomment and run code below:
#
# calculate_capacity(data_folder,
#                   signal_column,response_column,addVar_column,
#                   testing=TRUE)
