FROM archlinux

RUN pacman -Sy --noconfirm --overwrite '*'
RUN pacman -S pacman-mirrorlist --noconfirm --overwrite '*'
RUN pacman -Sy --noconfirm --overwrite '*'
RUN pacman -S git --noconfirm --overwrite '*'

FROM node:16

ARG APP
ENV APP=$APP

RUN env;

WORKDIR /app

COPY . .

RUN npm i -g pnpm@8.9.0
RUN pnpm i
RUN pnpm run build

EXPOSE 3000

CMD ["pnpm", "start"]
