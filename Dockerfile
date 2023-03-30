ARG TS_IMAGE_A=timescale/timescaledb-ha:pg15.2-ts2.10.1-latest
FROM ${TS_IMAGE_A} AS A
USER root
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait && mkdir /data && chown postgres:postgres /data
RUN apt-get update && apt-get install -y screen gdb sudo nano
RUN echo 'postgres ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ENV POSTGRES_PASSWORD=test
USER postgres
COPY with_postgres /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -c 'select 1'
COPY dataset/conditions_1.pgsql /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f /conditions_1.pgsql
#COPY dataset/devices_1/ devices_1
#RUN find . |grep sql && /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f devices_1/devices_1.sql

USER root
COPY dataset/devices_small devices_small
RUN cd devices_small && /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f load.pgsql


CMD [ "/with_postgres", "bash"]
