


gather_messages <- function(filename) {
  #leser inn fil med logg og identifiserer feilmeldinger
logfile <- readLines(con = filename)


#Identifiserer linjer med feilmeldinger og advarsler
error_lines<-grep("Error",logfile)
error_lines<-c(error_lines, error_lines+1, error_lines+2)

warning_lines<-grep("Warning",logfile)
warning_lines<-c(warning_lines,warning_lines+1)

message_lines<-unique(c(error_lines,warning_lines))
message_lines<-message_lines[order(message_lines)]

#Fjerner feilmeldinger som er klarert
allowed_lines <- grep("was built under R version", logfile) #Fjerner meldinger om at pakker er nyere enn R-versjonen
allowed_lines <- c(allowed_lines, allowed_lines-1)

#Fjerner feilmeldinger ved avslutning av R, skyldes at R kjøres fra mappe uten skriverettigheter
# Siste kommando i "Batch CWDrapporter fra EOS.R": print("Ferdig Batch CWDrapporter fra EOS")
finished <- grep("Ferdig Batch", logfile)

if (length(finished) > 0) {
  allowed_lines <- c(allowed_lines, finished:length(logfile))
}
message_lines<-message_lines[which(!message_lines %in% allowed_lines)]

#Lager liste over feilmeldinger og advarsler
messages<-as.data.frame(logfile[message_lines], StringAsFactors=FALSE)
messages<-paste(message_lines, messages[,1])

return(messages)


}
