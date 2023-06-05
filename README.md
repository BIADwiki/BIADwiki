<a href="http://biadwiki.org/"><img src="tools/logos/BIAD.logo.net.png" alt="BIAD" height="150"/></a>
# BIAD
## Big Interdisciplinary Archaeological Database
This github repository provides support for the BIAD wiki [biadwiki.org](http://biadwiki.org/) by providing a single collaborative repository to develop R code for three main purposes:

## 1. R scripts only for the server
Various summary statistics and images are generated automatically from BIAD and used to populate the BIADwiki.
These are coded in R, with file names 'auto.make.xxxxxx.R and run on the hosting server regularly. 
Files prefaced 'auto.make.daily.xxxxx.R' are run each day at 07:15.
Files prefaced 'auto.make.weekly.xxxxx.R' are run each week at 07:15.

## 2. Generic R scripts for users
Files prefaced 'example.xxxxx.R' are generic example files for end users wishing to interact with BIAD via R, for example when building a script to both query and analyse data.
Get a github account, then clone the whole repository to your local machine to use the scripts.
Credentials are confidential, so running these R scripts requires various objects to be first created, which can be obtained fro the database administrator:

user <- 'xxxxx'

password <- 'xxxxx'

hostname <- 'xxxxx'

hostuser <- 'xxxxx'

pempath <-'xxxxx'

These objects can be added to the R script as a boilerplate header, but it is more elegant to create a single file once only called .Rprofile, and put it in your cloned R folder. 
This file will not be visible on the github as it is on the .gitignore list. Creating the .Rprofile requires a new .txt file. When re-naming the file make sure that the ".txt" extension gets removed, and the file is .Rprofile.
Make sure that the file extensions are visible and editable when creating the .Rprofile. Otherwise you will end up with a .txt file "Rprofile".

## 3. Personal R scipts
Files prefaced 'private.xxxxx.R' in your cloned repository will not be tracked or saved on Github, so feel free to use these for your own personal analyses.
These files will only exist on your machine.



## admin workflow
The pipeline is run automatically by the admin account of the server.
A single bash script BIADwiki.sh is run by the crontab schedule. 
BIADwiki.sh invokes R to run a single R script controller.R.
The R script controller.R runs the auto.make.xxx.R scripts.
Login credentials for the local server are stored in the .Rprofile and therefore are automatically invoked when the server runs R in admin.

## Outside pipeline
Various R scripts produce outputs that do not need to be run regularly, or are once off tasks. 
These still reside in the R folder.


