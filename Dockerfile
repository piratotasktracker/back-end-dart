# Use latest stable channel SDK.
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
COPY entrypoint.sh /app/
RUN chmod +x /app/entrypoint.sh

# Define environment variables (example values, adjust as needed)
ENV MONGO_DB_URI="mongodb://servise-executor:123321@ac-ecmbsqn-shard-00-01.ixpqeoy.mongodb.net:27017,ac-ecmbsqn-shard-00-00.ixpqeoy.mongodb.net:27017,ac-ecmbsqn-shard-00-02.ixpqeoy.mongodb.net:27017/testdb?ssl=true&replicaSet=atlas-3qr3g8-shard-0&authSource=admin&retryWrites=true&w=majority"
ENV JWT_SECRET_KEY="QweEWsdQwdsdCalglcerkmSLfWdalsd2399ssd3f9wS"
ENV DB_TYPE="MONGODB"

# Start server using entrypoint script.
EXPOSE 8080
ENTRYPOINT ["/app/entrypoint.sh"]
