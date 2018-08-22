ARG JAVA_VERSION=10
FROM yidigun/centos-java${JAVA_VERSION}
MAINTAINER dklee@yidigun.com

ENV SCOUTER_VERSION 1.8.6

ADD . /
RUN mkdir -p /webapp/logs && \
    curl -jksSL https://github.com/scouter-project/scouter/releases/download/v${SCOUTER_VERSION}/scouter-min-${SCOUTER_VERSION}.tar.gz | \
    tar zxf - -C /webapp scouter/agent.java && \
    ln -sf ../../../config/scouter.conf /webapp/scouter/agent.java/conf/scouter.conf

ENTRYPOINT ["/webapp/bin/bootstrap.sh"]
CMD ["start"]
