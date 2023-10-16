FROM mobiledevops/flutter-sdk-image:3.10.1

# Run basic check to download Dark SDK
RUN flutter doctor

COPY app_code /app
WORKDIR /app

USER root

RUN rm -f .packages

RUN flutter clean
RUN flutter pub get
RUN flutter build apk

RUN mkdir /apk/
ENTRYPOINT cp build/app/outputs/apk/release/app-release.apk /apk/client.apk
