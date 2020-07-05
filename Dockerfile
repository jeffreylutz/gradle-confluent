FROM gradle

# Become gradle user
USER gradle

# CHANGE TO PROJECT DIRECTORY
WORKDIR /home/gradle/project

ENV JAVA_HOME /opt/java/openjdk
ENV JAVA_VERSION jdk8u252-b09
ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 6.5.1

# Look around
RUN ls -laF /home/gradle

COPY * /home/gradle/project/

# Build gradle-confluent
RUN env
RUN bash -c ./gradlew -S -Panalytics.buildTag=1.1.23 clean build release -Prelease.disableChecks -Prelease.localOnly

# Copy the files into docker image
#RUN mkdir $HOME/lib
#COPY build/libs/gradle-confluent*.jar $HOME/lib/.

# Define command
#CMD ["/deploy/provision.sh"]
