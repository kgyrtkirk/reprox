ARG TS_IMAGE=timescale/timescaledb:2.10.3-pg13
FROM ${TS_IMAGE}
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait
RUN apk add sudo procps

ENV POSTGRES_PASSWORD=test
COPY with_postgres /
RUN /with_postgres psql -c 'select 1'
COPY stage0.pgsql /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f stage0.pgsql
COPY query.pgsql /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f query.pgsql
COPY stage1.pgsql /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f stage1.pgsql
COPY query.pgsql /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f query.pgsql

CMD [ "/with_postgres", "bash"]
