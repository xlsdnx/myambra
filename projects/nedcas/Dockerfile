FROM tomcat:7-jre8

MAINTAINER Jono <jfinger@plos.org>
LABEL vendor="Public Library of Science"

RUN apt-get update && apt-get install -y --no-install-recommends mysql-client-5.5 \
  && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN rm -rf $CATALINA_HOME/webapps/*

ADD http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.35/mysql-connector-java-5.1.35.jar $CATALINA_HOME/lib/
ADD https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip /root/

WORKDIR /root
RUN unzip consul*.zip

RUN mkdir /etc/consul.d && echo '{"service": {"name": "nedcas", "port": 8080, "check": {"name":"basic request", "http": "http://localhost:8080/cas/login", "interval": "10s", "timeout":"2s"}}}' > /etc/consul.d/web.json

COPY run*.sh *.sql ./

RUN mkdir $CATALINA_HOME/webapps/ROOT ; echo '<meta http-equiv="refresh" content="0;url=cas/login"/>' > $CATALINA_HOME/webapps/ROOT/index.html

COPY ned-cas-*.war $CATALINA_HOME/webapps/cas.war
COPY context.xml $CATALINA_HOME/conf/

CMD bash /root/run.sh