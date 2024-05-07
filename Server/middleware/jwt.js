const jwt = require("jsonwebtoken");
const crypto = require("crypto");

/**
 * Generate token
 *
 * @param {*} user user object
 * @returns generated token
 */
function generateAccessToken(user) {
  return jwt.sign(
    { userId: user.id, userMail: user.email, confirmed: user.confirmed },
    process.env.JWT_ACCESS_SECRET,
    { expiresIn: "1h" },
  );
}

/**
 * Encrypt token
 *
 * @param {*} token generated token
 * @returns encrypted toked
 */
function hashToken(token) {
  return crypto.createHash("sha512").update(token).digest("hex");
}

/**
 * Verify if the token corresponds to the secret
 *
 * @param {*} token
 * @returns undefined if it fails
 */
function verifyToken(token) {
  return jwt.verify(token, process.env.JWT_ACCESS_SECRET);
}

function generateToken(id, longTerm = false) {
  if (!process.env.REFRESH_JWT_EXPIRE) {
    throw new Error("REFRESH_JWT_EXPIRE not found in .env");
  } else if (!process.env.JWT_EXPIRE) {
    throw new Error("JWT_EXPIRE not found in .env");
  } else if (!process.env.JWT_ACCESS_SECRET) {
    throw new Error("JWT_ACCESS_SECRET not found in .env");
  }
  const expireInSeconds = longTerm
    ? parseInt(process.env.REFRESH_JWT_EXPIRE)
    : parseInt(process.env.JWT_EXPIRE);
  return jwt.sign({ id }, process.env.JWT_ACCESS_SECRET, {
    expiresIn: expireInSeconds,
  });
}

module.exports = {
  generateAccessToken,
  hashToken,
  verifyToken,
};
