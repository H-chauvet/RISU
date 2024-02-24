FROM node:20.2.0

COPY . .
RUN npm install
RUN npx prisma generate
EXPOSE 3000
RUN npm install -g dotenv-cli
COPY start.sh .

CMD [ "bash", "-c", "npm run migration; npm start"]
