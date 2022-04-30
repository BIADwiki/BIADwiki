<a href="http://biadwiki.org/"><img src="tools/logos/BIAD.logo.round.png" alt="BIAD" height="70"/></a>
# BIAD
## Big Interdisciplinary Archaeological Database
This github repository provides support for the BIAD wiki [biadwiki.org](http://biadwiki.org/) 

## Auto images
Various summary statistics and images are generated automatically from BIAD and used to populate the BIADwiki.
These are coded in R, and run on the hosting server regularly. 

## admin workflow
The pipeline is run automatically by admin.
A single bash script BIADwiki.sh is run by the crontab schedule. 
BIADwiki.sh invokes R to run a single R script controller.R
Login credentials for the local server are stored in the .Rprofile and therefore are automatically invoked when the server runs R in admin.


