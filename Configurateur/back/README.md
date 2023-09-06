# Serveur du configurateur

## Description
Serveur du configurateur pour communiquer et stocker les informations envoyé par le front

## Prérequis
* node
* git
* git@github.com:H-chauvet/RISU.git

## Lancer le serveur sans docker
```bash
git clone git@github.com:H-chauvet/RISU.git
cd Configurateur/back/
npm install
npx prisma generate
npm run migration
npm start
```

## Lancer avec docker
```bash
git clone git@github.com:H-chauvet/RISU.git
cd Configurateur/back/
docker build -t configurateur-back .
docker run -d -p 3000:3000 --name configurateurserver configurateur-back
```

## Documentation du server
```bash
cd Configurateur/back/
npm start
```
* Le swagger contenant l'ensemble des routes seras accessible à l'url suivante: [http://localhost:3000/api-docs](http://localhost:3000/api-docs)

## Fichier d'environnement du back
Les variables suivantes doivent être présents pour le bon fonctionnement du serveur:
* DATABASE_URL
* JWT_ACCESS_SECRET
* MAIL_ADDRESS
* MAIL_PASS
