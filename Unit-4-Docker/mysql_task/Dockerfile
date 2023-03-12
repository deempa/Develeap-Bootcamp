FROM ubuntu:18.04

RUN apt-get update -y

RUN apt install -y mysql-server

RUN apt-get install -y mysql-server \
    && mkdir -p /var/lib/mysql /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

COPY ./my.cnf /etc/mysql/conf.d

CMD ["mysqld","--user","mysql"]
