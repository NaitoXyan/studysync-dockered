# Use the official MySQL image from Docker Hub
FROM mysql:latest

# Set environment variables
ENV MYSQL_ROOT_PASSWORD=
ENV MYSQL_DATABASE=studysync
ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=

# Copy MySQL data directory from host to container
COPY studysync /var/lib/mysql

# Optionally, you can add initialization scripts
# COPY init.sql /docker-entrypoint-initdb.d/

# Expose MySQL port
EXPOSE 3306

# Start MySQL service
CMD ["mysqld"]
