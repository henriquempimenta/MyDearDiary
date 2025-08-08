# Use a base image with Java and other tools pre-installed
FROM cirrusci/flutter:stable

# Set the working directory
WORKDIR /app

# Copy your project files into the container
COPY . .

# Grant execution rights to the entrypoint script
# This is useful if you create a custom script to run commands
RUN chmod +x /app/entrypoint.sh

# The entrypoint can be used to run commands like 'flutter pub get'
ENTRYPOINT [ "/app/entrypoint.sh" ]
