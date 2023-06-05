ARG TS_IMAGE=timescale/timescaledb:2.11.0-pg15
FROM ${TS_IMAGE}
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait
RUN apk add sudo procps

ENV POSTGRES_PASSWORD=test
COPY with_postgres /
# RUN /with_postgres psql -c 'select 1'
COPY dataset/conditions_1.pgsql /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f conditions_1.pgsql
COPY repro.pgsql /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f repro.pgsql

CMD [ "/with_postgres", "bash"]
