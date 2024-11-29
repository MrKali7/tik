# Use an official base image, e.g., Ubuntu or Alpine, depending on your project's needs
FROM ubuntu:20.04

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    bash \
    curl \
    git \
    && apt-get clean

# Set the working directory inside the container
WORKDIR /app

# Copy project files into the container
COPY Build_bots.sh /app/Build_bots.sh
COPY Run_bots.sh /app/Run_bots.sh
COPY bots_config.json /app/bots_config.json
COPY README.md /app/README.md

# Make the scripts executable
RUN chmod +x /app/Build_bots.sh /app/Run_bots.sh

# If Build_bots.sh installs dependencies, run it here
RUN ./Build_bots.sh

# Define the default command to run when the container starts
CMD ["./Run_bots.sh"]

