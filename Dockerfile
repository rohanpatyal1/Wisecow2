FROM ubuntu:20.04

# Avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y fortune-mod cowsay netcat && \
    rm -rf /var/lib/apt/lists/*

# Copy script
WORKDIR /app
COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

# Expose app port
EXPOSE 4499

# Run app
CMD ["./wisecow.sh"]
