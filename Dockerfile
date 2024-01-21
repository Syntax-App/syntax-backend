# Stage 1: Build your Spark Java service image
FROM maven:3.9.2-amazoncorretto-17 as builder

# Create a directory for your project
WORKDIR /app

# Copy the Maven POM file and source code
COPY ./source-code/pom.xml .
COPY ./source-code/src ./src

# Build your Maven project (skip tests)
RUN mvn clean package -Dmaven.test.skip

# Installing OpenSSL
RUN yum install -y openssl && \
    yum clean all

# Use SSL certificates to create Java Keystore
RUN --mount=type=secret,id=cert_fullchain,dst=/fullchain.pem \
    --mount=type=secret,id=cert_privkey,dst=/privkey.pem \
    --mount=type=secret,id=keystore_pass,dst=/tmp/keystore_TEMP.txt \
    mkdir /app/ssl && \
    export KEYSTORE_PASS=$(cat /tmp/keystore_TEMP.txt) && \
    openssl pkcs12 -export -in /fullchain.pem -inkey /privkey.pem -out /app/ssl/keystore.p12 -name syntax-ssl-keystore -password pass:${KEYSTORE_PASS} && \
    keytool -importkeystore -srckeystore /app/ssl/keystore.p12 -srcstoretype pkcs12 -srcstorepass ${KEYSTORE_PASS} -destkeystore /app/ssl/keystore.jks -deststoretype JKS -deststorepass ${KEYSTORE_PASS} -storepass ${KEYSTORE_PASS} -keypass ${KEYSTORE_PASS}

# Expose the port your Spark Java service listens on
EXPOSE 443

# Command to start your Spark Java service
CMD ["mvn", "exec:java"]
