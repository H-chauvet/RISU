# Front du configurateur

## Description
Application front du configurateur, permettant de créer son conteneur

## Prérequis
* flutter
* git

## Lancer l'application sans docker
```bash
git clone git@github.com:H-chauvet/RISU.git
cd Configurateur/front/
flutter run
```

## Lancer l'application avec docker
```bash
git clone git@github.com:H-chauvet/RISU.git
cd Configurateur/front/
docker build -t configurateur-front .
docker run -d -p 5000:5080 --name configurateur-app configurateur-front
```
