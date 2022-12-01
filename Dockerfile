# 운영 환경을 위한 도커 파일
# 운영 환경의 경우 -> 클라이언트의 요청은 nginx 가 이를 받아, 이미 빌드된 서버 어플리케이션을 통해 이를 처리한다 
# 따라서 어플리케이션 빌드가 먼저 수행되어야 하고 , 이를 builder stage 로 명시하였다
# builder stage
# FROM 에는 base image 를 명시
FROM node:alpine as builder
# workdir 을 명시하지 않을 경우, 기본적으로 루트 디렉토리에 먼저 접속하게 된다  
WORKDIR 'usr/src/app'
# Dockerfile 의 경우 각 instruction 을 순서대로 실행시킨다 
COPY package.json ./
RUN npm install 
COPY ./ ./
RUN npm run buil
# CMD 는 하나의 도커 파일당 한 번만 사용가능하다고 하는데 RUN 은 여러번 쓸 수 있는 듯 하다 

FROM nginx
# COPY 할 파일들은 builder stage 에서 /usr/src/app/build 라는 위치에 있는 것들이고 -> 이거를 ~~ 위치로 COPY
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
