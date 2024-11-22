library(shiny)
library(leaflet)
library(ggmap)
library(shinyTree)
library(data.tree)
source("R/functions.R")
source("R/functions.database.connect.R")
library(shinybusy)

add_busy_bar(color = "#FF0000",timeout=1000)

# Register your Google Maps API key
register_google(key = "AIzaSyCAXld-xHp2fE6QfAn94vtojVgERyNjuW8")#attention ac ma clef

conn <- init.conn(db.credential=list(BIAD_DB_USER="simon carrignon",BIAD_DB_PASS="simon carrignon",BIAD_DB_HOST="127.0.0.1",BIAD_DB_PORT=3307))

test.table = "Sites"
test.value = "S01285"



table.name=test.table
primary.value=test.value
keys <- get.keys(conn = conn)
x <- get.relatives(keys = keys, table.name = 'Sites', primary.value = 'S10050',conn = conn) 
x <- get.relatives(keys = keys, table.name = 'GraveIndividuals', primary.value = 'C03440',conn = conn) 

#' Retrieve Relatives from Database Table
#'
#' This function generates trees of ancestor or descendant records related to a specific entries a database table.
#'
#' @param table.name A string specifying the name of the table where the entry is.
#' @param primary.value The primary key value used to find the entry in the database.
#' @param directions A character vector indicating direction(s) for retrieving the data related to the entry 
#' Available options are "up" for ancestors and "down" for descendants. Default is both (`directions=c("up", "down")`).
#' @param conn A database connection object. Default is `NULL`.
#' @param db.credentials parameter for manual setup of database credentials. Default is `NULL`.
#'
#' @return A list containing a root element with one branch with all the data associated with the specific entry and two other branches storing trees as nested list with all related entries.
#' @export
#'
get.relatives <- function(table.name, primary.value, directions = c("up","down"), conn = NULL, db.credentials = NULL,zoption=FALSE){
    stopifnot(directions %in% c("up","down"))
    keys  <- get.keys(conn)
    dir.functions = c("up"=get.ancestors,"down"=get.decendants)
    names(directions)=directions
    trees=lapply(directions,function(dir)dir.functions[[dir]](keys=keys, table.name=table.name, primary.value = primary.value, conn = conn, db.credentials = db.credentials))
    root=list() #root is here for esthetic trees root -> 'S01200' followd by three branches: data up and down
    root[[primary.value]]=c(list(data=get.table.data(keys=keys, table.name, primary.value, conn, db.credentials,na.rm = F)),trees)
    return(root)
}


#' Retrieve Descendant Records from Database
#'
#' This function retrieves all descendant records related to a specified primary value in a database table.
#'
#' @param keys A data frame containing database information, including relationships between tables (obtained via `get.keys`)
#' @param table.name A string specifying the name of the table from which to start retrieving descendant records.
#' @param primary.value The primary key value from which to find descendant records. 
#' @param conn A database connection object. 
#' @param db.credentials manual database credentials. 
#'
#' @return A nested list containing data frames of descendant records for each related table.
#' @export
#'
get.decendants <- function(keys, table.name, primary.value, conn = NULL, db.credentials = NULL){

    if(is.null(primary.value))return(NULL)

    primary.column <- get.primary.column.from.table(keys, table.name)
    relative.info  <- subset(keys, REFERENCED_COLUMN_NAME==primary.column & REFERENCED_TABLE_NAME==table.name)
    if(nrow(relative.info) == 0) return(NULL)
    
    relative.tables <- relative.info$TABLE_NAME #table using the key
    relative.columns <- relative.info$COLUMN_NAME #name of column using the key
    res <- list()
    for(n in 1:length(relative.tables)){
        rt <- relative.tables[n]
        rc <- relative.columns[n]
        sql.command <- paste("SELECT * FROM `BIAD`.`",rt,"` WHERE ",rc," = '",primary.value,"'", sep='')
        data <- query.database(conn = conn, db.credentials = db.credentials, sql.command = sql.command)
        if(length(data)>0){
            relative.key  <- get.primary.column.from.table(keys, rt)
            res[[rt]]=list()
            res[[rt]][["data"]]  <- data
            for(rv in data[[relative.key]]){
                res[[rt]][[rv]] <- get.decendants(keys = keys,table.name = rt,primary.value = rv,conn = conn, db.credentials = db.credentials)
            }
        }
    }
    return(res)
}

#' Retrieve Ancestor Records from Database
#'
#' This function retrieves all ancestor records related to a specified primary value in a database table.
#'
#' @param keys A data frame containing database information, including relationships between tables (obtained via `get.keys`)
#' @param table.name A string specifying the name of the table from which to start retrieving descendant records.
#' @param primary.value The primary key value from which to find descendant records. 
#' @param conn A database connection object. 
#' @param db.credentials manual database credentials. 
#'
#' @return A nested list containing data frames of descendant records for each related table.
#' @export
#'
get.ancestors <- function(keys, table.name, primary.value, conn = NULL, db.credentials = NULL, orig.table = NULL , zoption = FALSE){

    relative.info  <- subset(keys, TABLE_NAME==table.name & grepl('FK_',CONSTRAINT_NAME))
    #if(!zoption) relative.info  <- subset(relative.info, !grepl('zoptions_',REFERENCED_TABLE_NAME))

    if(is.null(orig.table)) orig.table <- get.table.data(keys, table.name, primary.value, conn, db.credentials,na.rm = F) 

    if(nrow(relative.info) == 0) return(orig.table)
    
    relative.tables <- relative.info$REFERENCED_TABLE_NAME #table using the key
    relative.columns <- relative.info$REFERENCED_COLUMN_NAME #name of column using the key
    orig.column.alt <- relative.info$COLUMN_NAME #name of column using the key

    res <- list()
    for(n in 1:length(relative.tables)){
        rt <- relative.tables[n]
        rc <- relative.columns[n]
        rv.c <- orig.column.alt[n] #column where the reference value is stored
        if(rv.c %in% names(orig.table)){
            values <- unique(unlist(na.omit(orig.table[rv.c])))
            if(length(values) > 0){
                if(length(values) == 1) matchexp <- paste0(" = '",values,"'")
                if(length(values) > 1) matchexp <- paste0(" IN ('",paste0(values,collapse=","),"')")
                sql.command <- paste0("SELECT * FROM `BIAD`.`",rt,"` WHERE ",rc,matchexp)
                data <- query.database(conn = conn, db.credentials = db.credentials, sql.command = sql.command)
                if(length(data)>0){
                    relative.key  <- get.primary.column.from.table(keys, rt)
                    res[[rt]]=list()
                    res[[rt]][["data"]]  <- data
                    for(rv in data[[relative.key]]){
                        res[[rt]][[rv]] <- get.ancestors(keys = keys,table.name = rt,primary.value = rv,conn = conn, db.credentials = db.credentials, orig.table = data)
                    }
                }
            }
        }
    }
    return(res)
}

#' Retrieve BIAD size
#'
#' This function retrieves the sizes of BIAD, to help figuring out which dockers to use
#'
#' @param conn A database connection object. Default is `NULL`.
#' @param db.credential Unused parameter for database credentials. Default is `NULL`.
#'
#' @return A data frame with the database sizes in gigabytes.
#' @export
getSize <- function(conn = NULL, db.credential = NULL){
    sql.command='SELECT table_schema AS "Database", (SUM(data_length)+SUM(index_length)) / 1024 / 1024 / 1024 AS "Size (GB)" FROM information_schema.TABLES GROUP BY table_schema'
    query.database(sql.command,conn)
}
