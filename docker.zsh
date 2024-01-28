#!/bin/zsh
# if ! [ docker image inspect mysql:5.7.33 >/dev/null 2>&1 ]; then
# 	printf "MySQL 5.7.33 Docker image required.\n"
# 	docker pull --platform linux/amd64 mysql:5.7.33
# fi

# if ! [ docker image inspect portainer/portainer-ce:2.11.1-alpine >/dev/null 2>&1 ]; then
# 	printf "Portainer Docker image required.\n"
# 	docker pull portainer/portainer-ce:2.11.1-alpine

# 	if ! [ docker volume inspect portainer_data > /dev/null 2>&1 ]; then
# 		docker volume create portainer_data
# 	fi

# 	 docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
# 	 	--restart=always \
# 	 	-v /var/run/docker.sock:/var/run/docker.sock \
# 	 	-v portainer_data:/data \
# 	 	portainer/portainer-ce:2.11.1-alpine
# fi

# if ! [ docker volume inspect portainer_data > /dev/null 2>&1 ]; then
# 		printf "Creating portainer_data volume"
# fi
