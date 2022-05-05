FROM postgres

# https://github.com/2ndQuadrant/pglogical#installing-pglogical-with-apt
RUN apt-get update && apt-get install -y
RUN apt-get install curl -y
RUN curl https://techsupport.enterprisedb.com/api/repository/dl/default/release/deb | bash
RUN apt-get install postgresql-common -y
RUN /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y
RUN apt-get install postgresql-14-pglogical

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=1234
ENV POSTGRES_DB=shop

# https://github.com/vishnubob/wait-for-it
COPY ./wait-for-it.sh ./
COPY ./subscription.sh ./
COPY ./init-replication.sh /docker-entrypoint-initdb.d

# https://github.com/2ndQuadrant/pglogical#usage
# track_commit_timestamp used here for
# last_update_wins for conflict_resolution
# timestamp is used to check the last
CMD ["postgres", "-c", "wal_level=logical", "-c", "max_worker_processes=10", "-c", "max_replication_slots=10", "-c", "max_wal_senders=10", "-c", "shared_preload_libraries=pglogical", "-c", "track_commit_timestamp=on", "-c", "pglogical.conflict_resolution=last_update_wins"]
