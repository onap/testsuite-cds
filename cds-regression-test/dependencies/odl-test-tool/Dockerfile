FROM openjdk:14-alpine

# checkout and build https://git.opendaylight.org/gerrit/admin/repos/netconf
# wiki https://wiki.opendaylight.org/view/OpenDaylight_Controller:Netconf:Testtool
COPY netconf-testtool-1.8.0-executable.jar /opt/app/netconf-testtool/netconf-testtool-1.8.0-executable.jar
EXPOSE 17830
ENTRYPOINT ["java", "-Xmx1G", "-XX:MaxPermSize=256M", "-jar", "/opt/app/netconf-testtool/netconf-testtool-1.8.0-executable.jar"]

