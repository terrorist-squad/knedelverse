FROM ubuntu:latest
RUN apt update && apt -y install hugo -y
WORKDIR /hugo