ARG TS_IMAGE=timescale/timescaledb:2.10.1-pg15
FROM ${TS_IMAGE}
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait
RUN apk add sudo procps git

ENV POSTGRES_PASSWORD=test
COPY with_postgres /
# initialize db
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 -c 'select 1'
RUN git clone -b lost-default-1 https://github.com/kgyrtkirk/comp-test 
WORKDIR /comp-test
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 -v test=diff_mismatch.sql -f runner/test_runner.sql

CMD [ "/with_postgres", "bash"]
