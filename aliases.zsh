alias weather="curl -4 http://wttr.in"

# Recursively remove .DS_Store files
alias cleanupds="find . -type f -name '*.DS_Store' -ls -delete"

# IP Addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'