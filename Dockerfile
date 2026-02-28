FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml
COPY pom.xml .

# Create the correct package folder structure
RUN mkdir -p src/main/java/com/moviereview/controller \
    && mkdir -p src/main/java/com/moviereview/model \
    && mkdir -p src/main/java/com/moviereview/repository \
    && mkdir -p src/main/java/com/moviereview/service \
    && mkdir -p src/main/resources

# Copy all Java files into correct locations
COPY MovieReviewBackendAppApplication.java src/main/java/com/moviereview/
COPY ReviewController.java src/main/java/com/moviereview/controller/
COPY Review.java           src/main/java/com/moviereview/model/
COPY ReviewDTO.java        src/main/java/com/moviereview/model/
COPY ReviewRepository.java src/main/java/com/moviereview/repository/
COPY ReviewService.java    src/main/java/com/moviereview/service/
COPY application.properties src/main/resources/

RUN mvn clean install -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

