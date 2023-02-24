ARG TS_IMAGE=timescale/timescaledb:2.10.0-pg14
FROM ${TS_IMAGE}
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait
RUN apk add sudo procps
ENV POSTGRES_PASSWORD=test
COPY with_postgres /
RUN /with_postgres psql -c 'select 1'
ADD https://github.com/timescale/timescaledb/files/10820938/nanola-trungthao.zip /
RUN /with_postgres createuser web
RUN unzip nanola-trungthao.zip
COPY restore_dump /
RUN /with_postgres /restore_dump nanola-trungthao.pgd
COPY repro.pgsql /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f repro.pgsql

CMD [ "/with_postgres", "bash"]
