#------------------------------------------------------------------
# Runs all R scripts beginning with 'auto.make.'
# This script is invoked by a regular CRON schedule (Admin),
# However, some scripts need not be run so frequently.
# Rather than specifying a CRON schedule for each script, 
# this script decides when to run which script, based on the filename.
#------------------------------------------------------------------
# install BIADconnect if required
#if(!'BIADconnect'%in%installed.packages())devtools::install_github("BIADwiki/BIADconnect")
if(!'BIADconnect'%in%installed.packages())install.packages("~/BIADconnect/", repos = NULL, type = "source")
require(BIADconnect)
#------------------------------------------------------------------
run.day <- c('Thu')
today <- strsplit(date(),split=' ')[[1]][1]

conn  <-  init.conn()
cat(paste('BIAD check routine started on:\n',date(),'\n'))
cat(paste(' - BIAD size is of:',round(getSize(conn = conn)[1,2]*1000),'Mo\n'))
disconnect()

files <- list.files()
daily.files <- files[grepl('auto.make.daily',files)]
weekly.files <- files[grepl('auto.make.weekly',files)]

ND <- length(daily.files)
NW <- length(weekly.files)

fails <- 0
warnings <- 0
success <- 0

if(ND>0)for(n in 1:ND){
	file <- daily.files[n]
	tryCatch({
        cat(paste0("#-----------------------------------\n"));
        cat(paste('Starting to run script:',file,'at',date(),"\n"))
        source(file)
        cat(paste0("#------------ run ",file,", succeed ✅\n"));
        success <- success  + 1
    },
    error=function(err){
        fails <<- fails  + 1
        cat(paste0("#------------ run ",file,", failed ❌\n"));
        print(err)
	},
    warning=function(war){
        cat(paste0("#------------ run ",file,", got warning ⚠️\n"));
        print(war)
        warnings <<- warnings  + 1
	})
}

cat(paste0("#----------------\n"));
cat(paste0("summary of daily check made\n", date()," \n "));
cat(paste("❌:",fails,"/",ND,"failed\n"));
cat(paste("⚠️:",warnings,"/",ND," w/ warning \n"));
cat(paste("✅:",success,"/",ND,"succeed \n"));

fails <- 0
warnings <- 0
success <- 0

if(NW>0 & today%in%run.day){
    for(n in 1:NW){
        file <- weekly.files[n]
        tryCatch({
            cat(paste0("#-----------------------------------\n"));
            cat(paste('Starting to run script:',file,'at',date(),"\n"))
            source(file)
            cat(paste0("#------------ run ",file,", succeed ✅\n"));
            success <- success  + 1
        },
        error=function(err){
            cat(paste0("#------------ run ",file,", failed ❌\n"));
            print(err)
            fails <<- fails  + 1
        },
        warning=function(war){
            cat(paste0("#------------ run ",file,", warning ⚠️\n"));
            warnings <<- warnings  + 1
        })
    }

    cat(paste0("#----------------\n"));
    cat(paste0("summary of weekly check made on:\n", date(),"\n "));
    cat(paste("❌:",fails,"/",NW,"failed\n"));
    cat(paste("⚠️:",warnings,"/",NW," w/ warning \n"));
    cat(paste("✅:",success,"/",NW,"succeed \n"));
}
#------------------------------------------------------------------
	
	
	
	
