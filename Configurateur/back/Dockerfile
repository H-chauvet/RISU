FROM node:lts

COPY . .
RUN npm install
RUN npx prisma generate
EXPOSE 3000
RUN npm install -g dotenv-cli
COPY start.sh .

CMD [ "bash", "start.sh"]