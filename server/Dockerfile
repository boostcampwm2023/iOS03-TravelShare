FROM node:20.5.1 as BUILDER

RUN mkdir -p /var/app
WORKDIR /var/app
COPY . /var/app/
RUN npm install -g @nestjs/cli
RUN npm install
RUN npm run build

FROM node:20.5.1 as DISTRIBUTION

RUN mkdir -p /var/app/dist
WORKDIR /var/app
COPY --from=BUILDER /var/app/dist /var/app/dist
COPY --from=BUILDER /var/app/package.json /var/app/package.json
COPY --from=BUILDER /var/app/application.yaml /var/app/application.yaml
COPY --from=BUILDER /var/app/production.sh /var/app/production.sh
RUN npm install --production
EXPOSE 80
ENV NODE_ENV=production
ENTRYPOINT [ "sh /var/app/production.sh" ]