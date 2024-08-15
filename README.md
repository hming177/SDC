# SDC
This is a simple R program to crawl, merge and interpolate the daily closing prices of stock indices and their constituents. 
The program requires the "reticulate" package in R and python software to be installed. 
It is intended for R users to access financial data online in R software, for other functions see https://akshare.xyz/.
In R software, the "." in the concatenation function in python needs to be replaced with "$", for example, function ak.stock_zh_a_daily need be replaced by ak$stock_zh_a_daily. Without python and akshare installed, you can follow these steps:

###Open Rstudio as administrator
library(reticulate) 
install_miniconda() ## Install miniconda environment for python
miniconda_path()   
# miniconda_update()
conda_create("r-reticulate") ## Create an r-reticulate environment
use_condaenv("r-reticulate")
py_install("akshare", pip=TRUE) ## Install akshare package using pip
py_available()  ##Check if python is installed successfully
py_config()


