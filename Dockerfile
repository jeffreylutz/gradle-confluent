FROM openjdk:8-jdk-alpine

ENV GRADLE_VERSION 6.5.1

# get gradle and supporting libs
RUN apk -U add --no-cache curl; \
    curl https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip > gradle.zip; \
    unzip gradle.zip; \
    rm gradle.zip; \
    apk del curl; \
    apk update && apk add --no-cache libstdc++ && rm -rf /var/cache/apk/*

ENV PATH=${PATH}:/gradle-${GRADLE_VERSION}/bin

RUN mkdir -p /work
RUN mkdir -p /GRADLE_CACHE

# Gradle work directory
VOLUME work

# Gradle cache directory
VOLUME GRADLE_CACHE

RUN mkdir -p /build
WORKDIR /build

COPY * /build/

RUN ls -laF /build

RUN rm -rf /build/wrapper

RUN gradle wrapper
RUN ./gradlew -S -Panalytics.buildTag=1.1.24 clean build release -Prelease.disableChecks -Prelease.localOnly || echo ' '

# ./gradlew -S --no-daemon -Panalytics.buildTag=1.1.23 clean build release -Prelease.disableChecks -Prelease.localOnly

# Copy the files into docker image
RUN mkdir /gradlelibs
COPY /build/libs/gradle-confluent*.jar /gradlelibs/

RUN rm -rf /build

#ENTRYPOINT ["gradle", "-g", "/GRADLE_CACHE", "--no-daemon"]
