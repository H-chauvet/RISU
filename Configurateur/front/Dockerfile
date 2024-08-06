FROM dart:3.4.0 AS build-env

ARG 2.4.1

RUN apt-get update --quiet --yes
RUN apt-get install --quiet --yes \
    unzip \
    apt-utils \
    python3

RUN dart pub global activate fvm 2.4.1
RUN fvm install 3.22.0
RUN fvm global 3.22.0
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
