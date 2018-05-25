FROM python:2-onbuild

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user

COPY settings.py /settings.py
COPY tr-projects-rest.ini /tr-projects-rest.ini
#sudo uwsgi --ini tr-projects-rest.ini
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates nginx \
    && apt-get install -y git

RUN buildDeps=' \
    gcc \
    make \
    python \
    ' \
    && set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && pip install --upgrade pip \
    && git clone https://github.com/mirror-media/tr-projects-rest.git \
    && cd tr-projects-rest/ \
    && pip install flask \
    && pip install Eve \
	&& pip install uwsgi \
    && cp ../settings.py ../tr-projects-rest/settings.py \
	&& cp ../tr-projects-rest.ini ../tr-projects-rest/tr-projects-rest.ini \
    && uwsgi --ini tr-projects-rest.ini

EXPOSE 8080
CMD ["nginx"]
