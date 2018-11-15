# docker build -t appops.icp:8500/hpramod/scope-plus-ui:latest
FROM websphere-liberty
#ADD scopeplus.war /opt/ibm/wlp/usr/servers/defaultServer/dropins/###ContectPath###.war
ADD webapp/hello-world-war-1.0.0.war /opt/ibm/wlp/usr/servers/defaultServer/dropins/monolith-jboss.war
RUN /opt/ibm/wlp/bin/installUtility install  --acceptLicense appSecurity-2.0 ejbLite-3.1 ldapRegistry-3.0 localConnector-1.0 jaxrs-1.1 jdbc-4.1 jpa-2.0 jsp-2.3 servlet-3.1
ENV LICENSE accept
COPY db2jcc4.jar /db2jcc4.jar
COPY db2jcc_license_cisuz.jar /db2jcc_license_cisuz.jar
#COPY server.xml /config/server.xml
