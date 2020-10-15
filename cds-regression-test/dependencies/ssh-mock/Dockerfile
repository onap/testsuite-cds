FROM danielguerra/alpine-sshd:latest
COPY ./create-user.sh /opt/create-user.sh
COPY ./sshd_config /etc/ssh/sshd_config
RUN ["/opt/create-user.sh"]