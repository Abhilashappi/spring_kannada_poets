FROM tomcat:9.0

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file to Tomcat webapps as ROOT.war
COPY target/spring_kannada_poets-1.0.0.war /usr/local/tomcat/webapps/ROOT.war



# Expose the port your app will run on
EXPOSE 8084

# Start Tomcat server
CMD ["catalina.sh", "run"]

