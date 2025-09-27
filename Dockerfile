# Base image
FROM ubuntu:22.04

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y netcat-traditional fortune-mod cowsay && \
    rm -rf /var/lib/apt/lists/*

# Add script
COPY wisecow.sh ./

# Make it executable
RUN chmod +x wisecow.sh

# Expose port used by the script
EXPOSE 4499

# Run the script when container starts
CMD ["./wisecow.sh"]
