FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
	tini locales procps psmisc sudo less \
	netbase iproute2 net-tools iputils-ping curl \
	python3 python3-virtualenv python3-requests \
	vim cifs-utils nfs-common transmission-daemon \
	openvpn

### install webmin
RUN curl -L -o /webmin-current.deb https://www.webmin.com/download/deb/webmin-current.deb
RUN apt-get update -y && apt-get upgrade -y && \
		apt-get install -y --install-recommends /webmin-current.deb
RUN rm /webmin-current.deb

RUN sh -c "echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen"
RUN locale-gen
ENV LC_ALL=en_US.UTF-8

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/entrypoint.sh" ]
