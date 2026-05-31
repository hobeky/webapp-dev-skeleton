FROM node:20-alpine

RUN apk add --no-cache bash git openssh tini libc6-compat

WORKDIR /usr/src/app

EXPOSE 4200

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["sh", "-c", "npm install && npm run dev"]