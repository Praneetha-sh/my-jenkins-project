FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY . /app
RUN javac HelloWorld.java
CMD ["java", "HelloWorld"]
