FROM node:18-bullseye as builder

WORKDIR /app

COPY package.json /app
RUN npm install
COPY . /app
RUN make config=subnet-remaining-ips.yaml prepareEnv

FROM node:18-bullseye-slim as app

WORKDIR /app
COPY --from=builder /app/build/ /app/
COPY --from=builder /app/config/ /app/config/
RUN npm install
CMD config=subnet-remaining-ips.yaml node executor/lib/index.js
EXPOSE 4000