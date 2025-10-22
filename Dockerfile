FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies needed by wisecow.sh
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		bash \
		cowsay \
		fortune-mod \
		netcat-openbsd \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the wisecow script and make it executable
COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

EXPOSE 4499

# Run the shell-based server
CMD ["/bin/bash", "/app/wisecow.sh"]
