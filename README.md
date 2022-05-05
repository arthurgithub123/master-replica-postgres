# master-replica-postgres

###### This project has 2 containers. Each one with Postgres
###### database. One will be the master and another the replica.
#
###### The replica database waits automatically for the master
###### starting listening in its TCP Socket before it can
###### connect and subscribe to it to receive replication
###### data.
#
###### I put comments in the files and also in Dockerfiles
###### explaining the code for better understanding,
###### studying.
#
#
> There is still an error to fix: the auto increment in the tables as serial is being used. It causes an error if you insert some data in the replica table after a replication is done.
> But if do not want to use serial and use an id provided by an API there will be no problem.

### Dependencies in your machine
- Docker

### Running the application
1. Start Docker
2. Go to project root folder
3. Execute `docker compose up` to create the containers
4. Insert data into master database and then see it replicated
in the replica database
5. Check the logs in the console
