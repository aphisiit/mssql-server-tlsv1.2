FROM mcr.microsoft.com/mssql/server:2019-latest
USER root

ENV SA_PASSWORD=P@ssw0rd
ENV ACCEPT_EULA=Y

COPY container/sql1/mssql.conf /var/opt/mssql/mssql.conf
COPY container/sql1/mssql.pem /etc/ssl/certs/mssql.pem
COPY container/sql1/mssql.key /etc/ssl/private/mssql.key

EXPOSE 1433

HEALTHCHECK --interval=10s  \
	CMD /opt/mssql/bin/permissions_check.sh