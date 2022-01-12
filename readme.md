# MS Sql Server container with SSLProtocol TLSv1.2

To encrypt connections to SQL Server Linux containers, you will need a certificate with the following [requirements](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-encrypted-connections?view=sql-server-ver15).

Below is an example of how the connection can be encrypted to SQL Server Linux Containers. Here we use a Self-Signed Certificate, this should not be used for production scenarios for such environments, you should use CA certificates.

### Create a self-signed certificate (for test or non-production)
```shell
openssl req -x509 -nodes -newkey rsa:2048 -subj '/CN=sql1.contoso.com' -keyout container/sql1/mssql.key -out container/sql1/mssql.pem -days 365
```

### Change right permission 
```shell
chmod 440 /container/sql1/mssql.pem
chmod 440 /container/sql1/mssql.key
```

### Create mssql.conf
```conf
[network]
tlscert = /etc/ssl/certs/mssql.pem
tlskey = /etc/ssl/private/mssql.key
tlsprotocols = 1.2
forceencryption = 1
```

### Deploy sql container
```shell
docker run -e "ACCEPT_EULA=Y" \
    --user root \
    -e "SA_PASSWORD=P@ssw0rd" \
    -p 30000:1433 \
    --name sql1 \
    -h sql1 \
    -v $(pwd)/container/sql1/mssql.conf:/var/opt/mssql/mssql.conf \
    -v $(pwd)/container/sql1/mssql.pem:/etc/ssl/certs/mssql.pem \
    -v $(pwd)/container/sql1/mssql.key:/etc/ssl/private/mssql.key \
    -d mcr.microsoft.com/mssql/server:2019-latest
```

## More details
- [https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-docker-container-security?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-docker-container-security?view=sql-server-ver15)