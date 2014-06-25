FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y software-properties-common
RUN apt-get install -y tor
RUN apt-get install -y build-essential

RUN add-apt-repository ppa:pypy/ppa
RUN apt-get update
RUN apt-get install -y pypy pypy-dev

RUN curl -L https://raw.github.com/pypa/pip/master/contrib/get-pip.py | pypy

RUN pip install txtorcon
RUN pip install twisted

RUN apt-get purge -y build-essential
RUN apt-get autoclean -y

VOLUME /hidden_service
VOLUME /www_root

CMD ["twistd", "--pidfile=", "-n", "web", "--port=onion:80:hiddenServiceDir=/hidden_service", "--path=/www_root"]
