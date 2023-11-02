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

RUN npm i -g npm@8.3 pnpm@8.10.2
RUN pnpm i
RUN pnpm run build

EXPOSE 3000

CMD ["pnpm", "start"]
