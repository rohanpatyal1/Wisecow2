# Use Ubuntu as base
FROM ubuntu:22.04

# Install prerequisites
RUN apt-get update && \
    apt-get install -y fortune-mod cowsay netcat && \
    apt-get clean

# Copy the Wisecow script
COPY wisecow.sh /app/wisecow.sh

# Make the script executable
RUN chmod +x /app/wisecow.sh

# Expose the port used by Wisecow
EXPOSE 4499

# Start the Wisecow server
CMD ["/app/wisecow.sh"]

