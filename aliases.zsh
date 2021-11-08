# Display the weather
alias weather="curl -4 http://wttr.in"

# Recursively remove .DS_Store files
alias cleanupds="find . -type f -name '*.DS_Store' -ls -delete"

# IP Addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Docker - Use single quotes to avoid interpolation between double quotes.

# Start a Ruby image a shell to do Jekyll development in the current directory.
alias docker-blog='docker container run -it --rm -p 4000:4000 -v `pwd`:/blog ruby:2.7.3 /bin/bash'

# AWS
alias aws="docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws -e AWS_PROFILE amazon/aws-cli:2.3.4"
