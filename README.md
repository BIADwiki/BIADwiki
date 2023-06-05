<a href="http://biadwiki.org/"><img src="tools/logos/BIAD.logo.net.png" alt="BIAD" height="150"/></a>
# BIAD
## Big Interdisciplinary Archaeological Database
This github repository supports the BIAD wiki [biadwiki.org](http://biadwiki.org/) by providing a single collaborative repository to develop R code for three main purposes:

### 1. R scripts run only by the server
Various internal consistency checks, summary statistics and images are generated automatically from BIAD and used to populate the BIADwiki.
These R scripts are prefaced 'auto.make.xxxxxx.R and run on the hosting server regularly. 
Files prefaced 'auto.make.daily.xxxxx.R' are run each day at 07:15.
Files prefaced 'auto.make.weekly.xxxxx.R' are run once a week. 
A single bash script BIADwiki.sh is run by the crontab schedule. 
BIADwiki.sh invokes R to run a single R script controller.R.
The R script controller.R runs the auto.make.xxx.R scripts.
Login credentials for the local server are stored in the .Rprofile and therefore are automatically invoked when the server runs R in admin.

### 2. General example R scripts for users
Files prefaced 'example.xxxxx.R' are generic example files for end users wishing to interact with BIAD via R, for example when building a script to both query and analyse data.
Get a github account, then clone the whole repository to your local machine to use the scripts. If you want to collaborate with coding (rather than just use it) you will need to request permission to push, from the database administrator.
Credentials are confidential, so running these R scripts requires various objects to be first created, which can be obtained fro the database administrator:

user <- 'xxxxx'

password <- 'xxxxx'

hostname <- 'xxxxx'

hostuser <- 'xxxxx'

pempath <-'xxxxx'

These objects can be added to the R script as a boilerplate header, but it is more elegant to create a single file once only called .Rprofile, and put it in your cloned R folder. 
This file will not be visible on the github as it is on the .gitignore list. Creating the .Rprofile requires a new .txt file. When re-naming the file make sure that the ".txt" extension gets removed, and the file is .Rprofile.
Make sure that the file extensions are visible and editable when creating the .Rprofile. Otherwise you will end up with a .txt file "Rprofile".

### 3. Personal R scipts
Files prefaced 'private.xxxxx.R' in your cloned repository will not be tracked or saved on Github, so feel free to use these for your own personal analyses.
These files will only exist on your machine.






