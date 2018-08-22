
# Directory Structure

```
{your_work_dir}/
   +- Dockerfile
   +- README.md
   +- webapp
      +- bin/
      |  +- bootstrap.sh
      |  +- selftest.sh
      |  +- status.sh
      +- {your_application.jar}
      +- config/
      |  +- {your_application.yaml}
      |  +- selftest.yaml
      +- logs/
      +- README.md
```

# Edit your Dockerfile

```
FROM yidigun/centos-java10:latest
MAINTAINER {your_email}

COPY webapp /

EXPOSE 80
EXPOSE 443

ENV PATH=${PATH}:/webapp/bin
CMD /webapp/bin/bootstrap.sh
```

# Build Docker Image

```
cd {your_work_dir}
docker build -t {your_image_tag} .
```

# Selftest (on your server)

```
docker pull {your_image_tag}
docker run -it --rm {your_im$age_tag} selftest
```

# Run application

```
docker run -d \
--name {your_container_name} \
--restart unless-stopped \
-e TZ=Asia/Seoul \
-e LANG=ko_KR.UTF-8 \
-v {your_log_dir}:/webapp/logs \
-p {your_http_port}:80/tcp \
-p {your_https_port}:443/tcp \
{your_image_tag}
```

# Check status

```
docker exec -it {your_container_name} status
```
