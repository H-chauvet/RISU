module.exports = {
  testEnvironment: "node",
  roots: ["<rootDir>/"],
  testMatch: ["**/__tests__/**/*.js", "**/?(*.)+(spec|test).js"],
  collectCoverage: true,
  collectCoverageFrom: [
    "routes/**/*.js",
    "middleware/**/*.js",
    "controllers/**/*.js",
  ],
  coverageDirectory: "<rootDir>/coverage",
  coverageReporters: ["text", "lcov"],
};
