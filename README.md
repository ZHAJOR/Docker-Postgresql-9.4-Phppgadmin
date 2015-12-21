# Docker-Postgresql-9.4-Phppgadmin
A postgresql 9.4 server with phppgadmin

## Usage

First make the image :  
`docker build -t postgresql-phppgadmin .`  
Then a container :  
`docker run -d -p 12345:80 --name=postg postgresql-phppgadmin`  
You can now access the phppgadmin interface from http://127.0.0.1:12345/
The default password for user 'postgres' is 'postgres'.
