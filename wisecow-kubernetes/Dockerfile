FROM debian:bullseye-slim

# Install bash, netcat, fortune, cowsay
RUN apt-get update && apt-get install -y \
    bash \
    netcat \
    fortune-mod \
    cowsay \
    && rm -rf /var/lib/apt/lists/*

# Add /usr/games to PATH (Debian lo fortune/cowsay ekkada untayo)
ENV PATH="/usr/games:${PATH}"

# Copy script
COPY wisecow.sh /usr/local/bin/wisecow.sh
RUN chmod +x /usr/local/bin/wisecow.sh

EXPOSE 4499

CMD ["/usr/local/bin/wisecow.sh"]

