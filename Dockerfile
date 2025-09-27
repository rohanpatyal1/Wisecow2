FROM ubuntu:22.04

# Set working directory
WORKDIR /app

# Install required packages including bash
RUN apt-get update && \
    apt-get install -y bash netcat-traditional fortune-mod cowsay && \
    rm -rf /var/lib/apt/lists/*

# Add /usr/games to PATH for fortune/cowsay
ENV PATH="/usr/games:${PATH}"

# Copy the script and make it executable
COPY wisecow.sh ./
RUN chmod +x wisecow.sh

# Run the script
CMD ["./wisecow.sh"]
