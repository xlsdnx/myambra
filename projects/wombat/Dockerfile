FROM plos/tomcat:7

MAINTAINER Jono <jfinger@plos.org>
LABEL vendor="Public Library of Science"

# RUN apk add python py-pip
# COPY requirements.txt $HOME
# RUN pip install -r $HOME/requirements.txt

HEALTHCHECK CMD curl -f http://localhost:8080/ || exit 1

RUN mkdir $AMBRA_CONF && \
  cp $CATALINA_HOME/conf/* $AMBRA_CONF && \
  rm -rf $CATALINA_HOME/conf && \
  ln -s $AMBRA_CONF $CATALINA_HOME/conf

COPY run*.sh *.py $HOME
COPY wombat-*.war $CATALINA_HOME/webapps/ROOT.war

COPY wombat.yaml $AMBRA_CONF

CMD bash $HOME/run.sh
