ARG TS_IMAGE=timescaledev/timescaledb:nightly-pg15
FROM ${TS_IMAGE}
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait
RUN apk add sudo procps

ENV POSTGRES_PASSWORD=test
COPY with_postgres /
RUN /with_postgres psql -c 'select 1'
COPY uni* /
RUN ls -l /
RUN /with_postgres psql -v ON_ERROR_STOP=1 tsdb -f /unique_err.dump
#COPY repro.pgsql /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f unique_err.pgsql

CMD [ "/with_postgres", "bash"]
