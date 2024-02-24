#FROM ubuntu:20.04
#
## Install required packages and clean up
#RUN apt-get update && \
#    apt-get install -y curl unzip git libstdc++6 fonts-droid-fallback python3 && \
#    apt-get clean
#
## Download Flutter SDK from Flutter Github repo
#RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
#
## Set Flutter environment path
#ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
#
## Accept Android licenses automatically
#RUN yes | flutter doctor --android-licenses
#
## Enable flutter web
#RUN flutter upgrade
#RUN flutter config --enable-web
#
## Copy files to container and build
#RUN mkdir /app/
#COPY . /app/
#WORKDIR /app/
#RUN flutter build web
#
## Record the exposed port
#EXPOSE 5000
#
#COPY server/server.sh .
#
#CMD ["bash", "server/server.sh"]
    #Stage 1 - Install dependencies and build the app
    FROM dart:3.1.0 as build-env

    ARG 2.4.1

    RUN apt-get update --quiet --yes
    RUN apt-get install --quiet --yes \
        unzip \
        apt-utils \
        python3

    RUN dart pub global activate fvm 2.4.1
    RUN fvm install 3.13.1
    RUN fvm global 3.13.1
    ENV PATH="/root/fvm/default/bin:${PATH}"
    # Run flutter doctor
    RUN flutter doctor -v
    # Enable flutter web
    RUN flutter config --enable-web

    # Copy files to container and build
    RUN mkdir /app/
    COPY . /app/
    WORKDIR /app/
    RUN flutter clean
    RUN flutter pub get
    RUN flutter build web

    # Stage 2 - Create the run-time image
    CMD ["bash", "server/server.sh"]
