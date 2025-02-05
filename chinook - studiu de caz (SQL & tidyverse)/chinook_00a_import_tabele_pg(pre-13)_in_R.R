################################################################################
###           Interogari `tidyverse` vs SQL - BD Chinook (IE/CIG/SPE)
################################################################################
# -- ultima actualizare: 2021-03-15

#install.packages('tidyverse')
library(tidyverse)

setwd('/Users/marinfotache/Downloads/chinook')

############################################################################
# # --    Importul tabelelor din versiuni pre-13 ale PostgreSQL
############################################################################

## curatare sesiune curenta
rm(list = ls())

# install.packages('RPostgreSQL')
library(RPostgreSQL)

## incarcare driver PostgreSQL
drv <- dbDriver("PostgreSQL")


###  A. Stabilirea conexiunii cu BD PostgreSQL

## Windows
con <- dbConnect(drv, dbname="chinook", user="postgres",
                 host = 'localhost', password="postgres")

# Mac OS - PostgreSQL 9, 10, 11, 12
con <- dbConnect(drv, host='localhost', port='5432', dbname='chinook',
                 user='postgres', password='postgres')


# Mac OS - PostgreSQL 13 - NU FUNCTIONEAZA!!!!
con <- dbConnect(drv, host='localhost', port='5434', dbname='chinook',
                 user='postgres', password='postgres')
# Eroare"
# [...] authentication method 10 not supported


###  B. Extragerea numelui fiecarei tabele

tables <- dbGetQuery(con,
     "select table_name from information_schema.tables where table_schema = 'public'")
tables



###  C. Importul tuturor tabelelor
for (i in 1:nrow(tables)) {
     # extragrea tabelei din BD PostgreSQL
     temp <- dbGetQuery(con, paste("select * from ", tables[i,1], sep=""))
     # crearea dataframe-ului
     assign(tables[i,1], temp)
}


###  D. inchidere conexiuni PostgreSQL
for (connection in dbListConnections(drv) ) {
    dbDisconnect(connection)
}

###  E. Descarcare (din memorie) a driverului
dbUnloadDriver(drv)

###  F. Salvarea tuturor dataframe-urilor din
###  sesiunea curenta ca fisier .writeData

# # stergere obiecte inutile
rm(con, drv, temp, i, tables, connection, chinook__pg_to_neo4j)


#setwd('D:/chinook')
setwd('/Users/marinfotache/Downloads/chinook')
getwd()

# salvare
save.image(file = 'chinook.rdata')

# stergerea tuturor obiectelor din sesiunea curenta R
rm(list = ls())

