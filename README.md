<a href="http://biadwiki.org/"><img src="tools/logos/BIAD.logo.round.png" alt="BIAD" height="70"/></a>
# BIAD
## Big Interdisciplinary Archaeological Database
This github repository provides support for the BIAD wiki [biadwiki.org](http://biadwiki.org/) 

## auto.make
Various summary statistics and images are generated automatically from BIAD and used to populate the BIADwiki.
These are coded in R, with file names 'auto.make.xxxxxx.R and run on the hosting server regularly. 
Files prefaced 'auto.make.daily.xxxxx.R' are run each day at 07:15.
Files prefaced 'auto.make.weekly.xxxxx.R' are run each week, on Monday morning at 07:15.

## admin workflow
The pipeline is run automatically by the admin account of the server.
A single bash script BIADwiki.sh is run by the crontab schedule. 
BIADwiki.sh invokes R to run a single R script controller.R.
The R script controller.R runs the auto.make.xxx.R scripts.
Login credentials for the local server are stored in the .Rprofile and therefore are automatically invoked when the server runs R in admin.

## Outside pipeline
Various R scripts produce outputs that do not need to be run regularly, or are once off tasks. 
These still reside in the R folder.
