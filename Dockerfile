FROM ubuntu:noble
ENV DEBIAN_FRONTEND noninteractive

RUN apt update
RUN apt install -y supervisor python3-pip python3-virtualenv cron

RUN apt clean && apt autoclean && rm -fr /var/lib/apt/lists/* && rm -fr /tmp/*

WORKDIR /app
COPY ./requirements.txt /app/requirements.txt
RUN virtualenv venv
RUN venv/bin/pip install -r /app/requirements.txt
COPY ./ /app

WORKDIR /

RUN (crontab -l ; echo "*/2 * * * * /app/venv/bin/python /app/manage.py cleanup") | crontab
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]
