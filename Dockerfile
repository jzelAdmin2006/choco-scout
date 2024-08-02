FROM chocolatey/choco:latest

RUN apt update && \
    apt install -y git wget apt-transport-https software-properties-common

RUN git config --global user.email "jzelbot.creatable458@passinbox.com"
RUN git config --global user.name "jzelBot"

RUN VERSION_ID=$(grep 'VERSION_ID' /etc/os-release | cut -d '"' -f 2) && \
    wget -q https://packages.microsoft.com/config/debian/${VERSION_ID}/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb

RUN apt update && \
    apt install -y powershell

RUN pwsh -Command "Install-Module Chocolatey-AU -Force -Scope AllUsers"
RUN mkdir -p /opt/chocolatey/helpers /chocolatey/au/chocolatey/helpers/functions

WORKDIR /workspace
COPY scout.ps1 /workspace/scout.ps1
RUN chmod +x /workspace/scout.ps1
ENTRYPOINT ["pwsh", "/workspace/scout.ps1"]
