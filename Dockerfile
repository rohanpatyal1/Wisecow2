# Use Ubuntu as base image
FROM ubuntu:20.04

# Install prerequisites
RUN apt-get update && apt-get install -y \
    fortune-mod \
    cowsay \
    netcat \
    && rm -rf /var/lib/apt/lists/*

# Copy the wisecow script
COPY wisecow.sh /usr/local/bin/wisecow.sh

# Make it executable
RUN chmod +x /usr/local/bin/wisecow.sh

# Ensure script has Unix line endings inside the image (fix CRLF from Windows hosts)
RUN sed -i 's/\r$//' /usr/local/bin/wisecow.sh
 
# Ensure fortune and cowsay are on PATH (they may be installed to /usr/games)
RUN if [ -x /usr/games/fortune ] && [ ! -x /usr/local/bin/fortune ]; then ln -s /usr/games/fortune /usr/local/bin/fortune; fi \
 && if [ -x /usr/games/cowsay ] && [ ! -x /usr/local/bin/cowsay ]; then ln -s /usr/games/cowsay /usr/local/bin/cowsay; fi

# Expose port
EXPOSE 4499

# Run the application
CMD ["/usr/local/bin/wisecow.sh"]
