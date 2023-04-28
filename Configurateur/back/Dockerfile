FROM node:latest

COPY . .
RUN npm install
RUN npx prisma generate
EXPOSE 3000
RUN npm install -g dotenv-cli
RUN ["chmod", "+x", "./start.sh"]

ENTRYPOINT [ "./start.sh"]