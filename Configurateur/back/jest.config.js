module.exports = {
  testEnvironment: "node", // ou 'jsdom' si vous travaillez avec le navigateur
  roots: ["<rootDir>/"], // Chemin vers le répertoire principal de votre code source
  testMatch: ["**/__tests__/**/*.js", "**/?(*.)+(spec|test).js"], // Modèle pour les fichiers de test
  collectCoverage: true, // Active la collecte de la couverture de code
  setupFilesAfterEnv: ["<rootDir>/jest.setup.js"],
  collectCoverageFrom: [
    "routes/**/*.js",
    "middleware/**/*.js",
    "controllers/**/*.js",
  ], // Spécifie les fichiers à inclure dans la couverture
  coverageDirectory: "<rootDir>/coverage", // Spécifie le répertoire de sortie pour les rapports de couverture
  coverageReporters: ["text", "lcov"], // Rapports de couverture à générer
  // ... d'autres configurations personnalisées peuvent être ajoutées ici
};
