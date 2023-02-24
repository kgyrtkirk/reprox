
# dump / restore test 
#rom 2.7.2 then Timescale cloud is on 2.8.1.
ARG TS_IMAGE_A=timescale/timescaledb:2.8.1-pg14
# ARG TS_IMAGE_B=timescale/timescaledb:2.7.2-pg14
ARG TS_IMAGE_B=timescale/timescaledb:2.9.1-pg14
FROM ${TS_IMAGE_A} AS A
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait
RUN apk add sudo procps

ENV POSTGRES_PASSWORD=test
COPY with_postgres /
RUN /with_postgres createdb tsdb
COPY dataset.pgsql /
RUN /with_postgres psql -a -v ON_ERROR_STOP=1 tsdb -f dataset.pgsql
RUN /with_postgres /create_dataset
COPY build_dump /
RUN /with_postgres /build_dump
# COPY create_dataset2 /
# RUN /with_postgres /create_dataset2
#COPY run_q1 /
#RUN /with_postgres /run_q1


FROM ${TS_IMAGE_B} AS B
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait
RUN apk add sudo procps
ENV POSTGRES_PASSWORD=test
COPY --from=A /backup.pg /
COPY with_postgres /
COPY restore_dump /
RUN /with_postgres /restore_dump
#COPY run_queries /
#RUN /with_postgres /run_queries
# COPY run_q1 /
# RUN /with_postgres /run_q1

CMD [ "/with_postgres", "psql" ,"tsdb"]
