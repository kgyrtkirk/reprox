ARG TS_IMAGE=timescale/timescaledb:2.10.1-pg15
FROM ${TS_IMAGE}
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait
RUN apk add sudo procps

ENV POSTGRES_PASSWORD=test
COPY with_postgres /
# RUN /with_postgres psql -c 'select 1'
#COPY dataset/conditions_1.pgsql /
#RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f conditions_1.pgsql
RUN /with_postgres ls
COPY repro /
RUN /with_postgres /repro
COPY repro2 /
RUN /with_postgres /repro2

CMD [ "/with_postgres", "bash"]
