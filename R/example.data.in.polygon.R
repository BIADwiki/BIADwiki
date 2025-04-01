#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
# get all sites within a polygon
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
# Requirements first read:
# https://biadwiki.org/en/connectR
# 1. ensure you have opened a tunnel first (e.g. putty)
# 2. eusure you have installed BIADconnect
#--------------------------------------------------------------------------------------
if(!'BIADconnect'%in%installed.packages())devtools::install_github("BIADwiki/BIADconnect")
require(BIADconnect)
conn  <-  init.conn()
#--------------------------------------------------------------------------------------
library(mapdata)
#--------------------------------------------------------------------------------------
# get all sites within a polygon
#--------------------------------------------------------------------------------------
x <- query.database("SELECT `Longitude`,`Latitude` FROM `BIAD`.`Sites`", conn=conn)
d <- data.in.polygon(data=x,kml.path='../tools/kml/square.kml')
#--------------------------------------------------------------------------------------
# look at the data
#--------------------------------------------------------------------------------------
xlim <- c(-10,50)
ylim <- c(40,60)
plot(NULL,xlim=xlim,ylim=ylim,frame.plot=F,axes=F, xlab='',ylab='',main='square')
map('world',xlim=xlim,ylim=ylim,col='grey90',add=T, fill=T, border='grey')
points(d$Longitude, d$Latitude, pch=16)
#--------------------------------------------------------------------------------------
disconnect()
#--------------------------------------------------------------------------------------
