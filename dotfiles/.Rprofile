################################################################################
# .Rprofile
#   R startup configuration
################################################################################

# Something changed wtih 3.4.1 that caused local library problems.  Temporary fix:
# https://stackoverflow.com/questions/44861967/r-3-4-1-single-candle-personal-library-path-error-unable-to-create-na
# .libPaths(c("/home/matt/R/x86_64-pc-linux-gnu-library/3.4/", .libPaths()))

if (interactive()) {

  options(repos = c(CRAN = "https://cran.rstudio.com"))
  # Colors in terminal R 
  if (!require(crayon)) { install.packages("crayon") }

  # Auto-adjust output width in terminal - vim-r-plugin recomm'n
  # if (Sys.info()["sysname"] == "Darwin") n <- 6 else n <- 7
  # width <- as.integer(system(paste0("stty -a | head -n 1 | awk '{print $", n, "}' | sed 's/;//'"), intern=T))
  # options(width = width)
  # rm(n, width)

  # wideScreen <- function(howWide=Sys.getenv("COLUMNS")) {
  #     options(width=as.integer(howWide))
  # }
  # Sys.getenv("COLUMNS")
  # wideScreen()
  options(blogdown.rmd = TRUE)
  options(blogdown.author = 'Matt')

  cowsay::say(praise::praise(), by = "random")

}


# Load environment variables
#source("~/.R_env_vars")
source("~/.Renviron") 

