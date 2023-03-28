ARG TS_IMAGE=timescale/timescaledb:2.10.1-pg14
FROM ${TS_IMAGE}
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait
RUN apk add sudo procps

ENV POSTGRES_PASSWORD=test
COPY with_postgres /
ENV TS_VERSION=2.9.3
# RUN /with_postgres psql -c 'select 1'
COPY create.pgsql /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f create.pgsql
COPY load.pgsql /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f load.pgsql
COPY compress.pgsql /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f compress.pgsql
COPY load2.pgsql /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f load2.pgsql
COPY repro /
RUN /with_postgres /repro

CMD [ "/with_postgres", "bash"]
