FROM ubuntu:20.04

# Install required packages and clean up
RUN apt-get update && \
    apt-get install -y curl unzip git libstdc++6 fonts-droid-fallback python3 && \
    apt-get clean

# Download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set Flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Accept Android licenses automatically
RUN yes | flutter doctor --android-licenses

# Enable flutter web
RUN flutter upgrade
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter build web

# Record the exposed port
EXPOSE 5000

COPY server/server.sh .

CMD ["bash", "server/server.sh"]
