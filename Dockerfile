# 빌드 단계
FROM maven:3.9.9-amazoncorretto-21 AS build

WORKDIR /app

# gradle 캐시를 활용하기 위해 필요한 파일 먼저 복사
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 소스 코드 복사 및 빌드
COPY src ./src
RUN mvn package -DskipTests

# 실행 단계
FROM amazoncorretto:21

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

ENV JAVA_OPTS="-Xms512m -Xmx512m"
ENV SERVER_PORT=8080

EXPOSE 8080

ENTRYPOINT ["java", "-Xms512m", "-Xmx512m", "-jar", "app.jar"]
