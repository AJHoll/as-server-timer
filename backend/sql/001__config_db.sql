create database "server-timer";
CREATE ROLE "timer-user" SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN PASSWORD 'timer-user-password';
alter database "server-timer" owner to "timer-user";