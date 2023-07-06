# Configurateur

## Description de l'application

Le configurateur permet de créer des conteneurs de location RISU sur-mesure, avec de multiples possibilités:
* nombre de casiers
* leurs formes
* le design de ceux-ci

## Prérequis
* docker
* docker-compose
* git

## Lancer l'application avec docker
```bash
git clone git@github.com:H-chauvet/RISU.git
cd Configurateur/
docker-compose build && docker-compose up
```

## Lancer l'application sans docker
```bash
git clone git@github.com:H-chauvet/RISU.git
cd Configurateur/front/
flutter run

cd ../back/
npm install
npm start
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
