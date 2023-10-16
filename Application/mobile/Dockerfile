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

RUN flutter upgrade

COPY app_code /app
WORKDIR /app

USER root

RUN rm -f .packages

RUN flutter clean
RUN flutter pub get
RUN flutter build apk

RUN mkdir /apk/
ENTRYPOINT cp build/app/outputs/apk/release/app-release.apk /apk/client.apk
