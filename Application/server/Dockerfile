FROM node:20.2.0

COPY . .
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/cert.pem /etc/nginx/
COPY nginx/key.pem /etc/nginx/
RUN npm install
EXPOSE 8080
RUN npm install -g dotenv-cli
RUN npx prisma generate

RUN ["chmod", "+x", "./start.sh"]

ENTRYPOINT [ "./start.sh"]