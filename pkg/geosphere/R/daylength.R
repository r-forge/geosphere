# Author: Robert J. Hijmans, r.hijmans@gmail.com
# License GPL3
# Version 0.1  January 2009

.doyFromDate <- function(date) {
	date <- as.character(date)
	as.numeric(format(as.Date(date), "%j"))
}

daylength <- function(lat, doy) {
	if (class(doy) == 'Date' | class(doy) == 'character') { 
		doy <- .doyFromDate(doy) 
	}
	if (lat > 90) { stop("lat should be <= 90") 
	} else if (lat < -90) { stop("lat should be >= -90") }	

	doy[doy==366] <- 365
	doy[doy < 1] <- 365 + doy[doy < 1]
	doy[doy > 365] <- doy[doy > 365] - 365 
	if (sum(doy[doy<1]) > 0) { stop('cannot understand value for doy') }
	if (sum(doy[doy>365]) > 0) { stop('cannot understand value for doy') }
	
#Forsythe, William C., Edward J. Rykiel Jr., Randal S. Stahl, Hsin-i Wu and Robert M. Schoolfield, 1995.
#A model comparison for daylength as a function of latitude and day of the year. Ecological Modeling 80:87-95.
	P <- asin(0.39795 * cos(0.2163108 + 2 * atan(0.9671396 * tan(0.00860*(doy-186)))))
	a <-  (sin(0.8333 * pi/180) + sin(lat * pi/180) * sin(P)) / (cos(lat * pi/180) * cos(P));
	a <- pmin(pmax(a, -1), 1)
	DL <- 24 - (24/pi) * acos(a)
	return(DL)
}


.daylength2 <- function(lat, doy) {
	if (class(doy) == 'Date' | class(doy) == 'character') { 
		doy <- .doyFromDate(doy) 
	}
	if (lat > 90) { stop("lat should be <= 90")
	} else if (lat < -90) { stop("lat should be >= -90")}	
	doy[doy==366] <- 365
	doy[doy < 1] <- 365 + doy[doy < 1]
	doy[doy > 365] <- doy[doy > 365] - 365 
	if (sum(doy[doy<1]) > 0) { stop('cannot understand value for doy') }
	if (sum(doy[doy>365]) > 0) { stop('cannot understand value for doy') }

# after Goudriaan and Van Laar
	RAD <- pi/180
#  Sine and cosine of latitude (LAT)
    SINLAT <- sin(RAD * lat);
    COSLAT <- cos(RAD * lat);
# Maximal sine of declination;}
    SINDCM <- sin(RAD * 23.45)
#{Sine and cosine of declination (Eqns 3.4, 3.5);}
    SINDEC <- -SINDCM * cos(2*pi*(doy+10)/365)
    COSDEC <- sqrt(1-SINDEC*SINDEC);
#The terms A and B according to Eqn 3.3;}
    A <- SINLAT*SINDEC;
    B <- COSLAT*COSDEC;
    C <- A/B;
#Daylength according to Eqn 3.6; arcsin(c) = arctan(c/sqrt(c*c+1))}
    DAYL <- 12* (1+(2/pi)* atan(C/sqrt(C*C+1)))
	return(DAYL)
}
