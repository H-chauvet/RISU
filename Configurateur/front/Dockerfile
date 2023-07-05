FROM ubuntu:20.04

RUN apt-get update 
RUN apt-get install -y curl git unzip libglu1-mesa wget libstdc++6 fonts-droid-fallback python3
RUN apt-get clean

# download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor

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

# make server startup script executable and start the web server
#RUN ["chmod", "+x", "/app/server/server.sh"]

#CMD [ "/app/server/server.sh"]
