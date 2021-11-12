# pull down the pode image
FROM badgerati/pode:latest

RUN apt-get -y update \
    && apt-get -y install net-tools make python nano curl ca-certificates gnupg lsb-release wget apt-transport-https software-properties-common


RUN curl --insecure -sL https://aka.ms/InstallAzureCLIDeb | bash

# or use the following for GitHub
# FROM docker.pkg.github.com/badgerati/pode/pode:latest

# copy over the local files to the container
COPY ./pwsh /usr/src/app/

# expose the port
EXPOSE 8080

# run the server
CMD [ "pwsh", "-c", "cd /usr/src/app; ./web-pages-docker.ps1" ]