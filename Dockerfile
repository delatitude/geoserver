FROM java:openjdk-8-jre-alpine

MAINTAINER Rodrigo Zanato Tripodi <rodrigo.tripodi@neoway.com.br>

EXPOSE 8080

ARG GEOSERVER_VERSION=2.15.0

ENV JAVA_OPTS -Xms128m -Xmx512m -XX:MaxPermSize=512m
ENV ADMIN_PASSWD geoserver

RUN apk add --update openssl
RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-bin.zip \
         -O /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip && \
    mkdir /opt && \
    unzip /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip -d /opt && \
    cd /opt && \
    ln -s geoserver-${GEOSERVER_VERSION} geoserver && \
    rm /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip

RUN wget -c https://download.microsoft.com/download/0/2/A/02AAE597-3865-456C-AE7F-613F99F850A8/sqljdbc_6.0.8112.200_enu.tar.gz \
         -O /tmp/geoserver-sqljdbc_6.0.8112.200_enu.tar.gz && \
         mkdir /tmp/geoserver-untar
RUN tar -C /tmp/geoserver-untar -zxvf /tmp/geoserver-sqljdbc_6.0.8112.200_enu.tar.gz
COPY /tmp/geoserver-untar/sqljdbc_6.0/enu/jre8/sqljdbc42.jar  /geoserver-2.15.0/webapps/geoserver/WEB-INF/lib/

ADD startup.sh /geoserver-$GEOSERVER_VERSION/bin/startup.sh
RUN chmod +x /geoserver-$GEOSERVER_VERSION/bin/startup.sh

WORKDIR /geoserver-$GEOSERVER_VERSION
CMD ["/geoserver$-${GEOSERVER_VERSION}/bin/startup.sh"]
