FROM archlinux

RUN pacman -Sy --noconfirm --overwrite '*'
RUN pacman -S git --noconfirm --overwrite '*'

FROM node:16

ARG APP
ENV APP=$APP

RUN env;

WORKDIR /app

COPY . .

RUN npm ci
RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
