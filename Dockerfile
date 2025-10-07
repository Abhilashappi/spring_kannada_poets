FROM tomcat:9.0

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file to Tomcat webapps as ROOT.war
COPY target/spring-kannada-poets-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose the port your app will run on
EXPOSE 8083

# Start Tomcat server
CMD ["catalina.sh", "run"]
