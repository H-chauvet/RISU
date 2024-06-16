FROM ghcr.io/cirruslabs/flutter:stable

COPY app_code /app
WORKDIR /app

USER root

RUN rm -f .packages

RUN flutter pub get
RUN flutter build apk

RUN mkdir -p /apk
RUN cp build/app/outputs/flutter-apk/app-release.apk /apk/client.apk

# Entrypoint to copy the APK and then exit
ENTRYPOINT ["sh", "-c", "cp build/app/outputs/flutter-apk/app-release.apk ../apk/client.apk && echo 'APK copied' && exit 0"]
