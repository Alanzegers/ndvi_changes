# Teamname*
# January 2016
# Calculate NDVI R Script

CalcNDVI <- function(x, y) {
	ndvi <- (y - x) / (x + y)
	return(ndvi)
}