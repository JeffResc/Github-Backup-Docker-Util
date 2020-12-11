FROM alpine:3.12.2
LABEL maintainer="jeff@jeffresc.dev"

ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 rclone git coreutils zip && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

RUN pip install github-backup

COPY ./script.sh /root/script.sh
RUN chmod +x /root/script.sh

CMD ["/root/script.sh"]