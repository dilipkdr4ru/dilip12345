FROM jenkins/jenkins:latest                                                                                                                                                                       

USER root

# Install dependencies for GitHub CLI installation (avoid `sudo` inside RUN)
RUN apt-get update && apt-get install -y wget gnupg2 && apt-get install -y docker.io

# Install GitHub CLI keyring (avoid `sudo` with `--no-install-recommends` for efficiency)
RUN wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /etc/apt/keyrings/githubcli-archive-keyring.gpg

# Set appropriate permissions for keyring file
RUN chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

# Add GitHub CLI repository configuration
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list

# Update package list and install GitHub CLI
RUN apt-get update && apt-get install -y gh --no-install-recommends

# Expose Jenkins port
EXPOSE 8080

# Command to run Jenkins
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]