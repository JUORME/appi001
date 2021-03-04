 nametienda <- function(x){
    x <- gsub("000001","MD01_LUZ", x,ignore.case = FALSE)
    x <- gsub("000002","MD02_JRC", x,ignore.case = FALSE)
    x <- gsub("000003","MD03_CRH", x,ignore.case = FALSE)
    x <- gsub("000004","MD04_SUC", x,ignore.case = FALSE)
    x <- gsub("000005","MD05_CRZ", x,ignore.case = FALSE)
    }
  