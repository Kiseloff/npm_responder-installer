# NPM responder installer

NPM responder platform installer

## Run 

### Interactive mode
User is prompted to setup application from command line.

Example:

```{r, engine='bash', count_lines}
docker run -it --rm \
  --name npm_responder-installer \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  kiseloff/npm_responder-install:latest
```

### Non-interactive mode
Setup is done based on environment variables passed to installer. 
Interactive mode must be set to 0 (disabled).

Example:

```{r, engine='bash', count_lines}
docker run -it --rm \
  --name npm_responder-installer \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  -e INTERACTIVE=0 \
  -e STACK_NAME=npmresponder \
  -e APP_WEBUI_PORT=8080 \
  -e APP_API_EXTERNAL_IP=<IP ADDRESS> \
  -e APP_API_PORT=5001 \
  -e APP_TELNETSRV_PORT=8023 \
  -e APP_USERNAME=<USERNAME> \
  -e APP_SNMPv3_SECRET=<SECRET1> \
  -e APP_SSH_SECRET=<SECRET2> \
  -e APP_COMMUNITY=public
  kiseloff/npm_responder-install:latest
```

#### Parameters

##### Mandatory 

- INTERACTIVE - must be set to **0** (disabled)
- APP_API_EXTERNAL_IP - must be IPv4 address (like 10.1.1.1)
- APP_USERNAME - username for SSH and SNMPv3 connections
- APP_SNMPv3_SECRET - secret for SNMPv3 connections
- APP_SSH_SECRET - secret for SSH connections

##### Optional 

- STACK_NAME - default to **npmresponder**
- APP_WEBUI_PORT - default to **8080**
- APP_API_PORT - default to **5001**
- APP_TELNETSRV_PORT - default to **8023**
- APP_COMMUNITY - default to **public**
