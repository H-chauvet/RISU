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
    {
      userId: user.id,
      userMail: user.email,
      confirmed: user.confirmed,
      userUuid: user.uuid,
      role: user.role,
    },
    process.env.JWT_ACCESS_SECRET,
    { expiresIn: "1h" }
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

function decodeToken(token) {
  return jwt.decode(token);
}

module.exports = {
  generateAccessToken,
  hashToken,
  verifyToken,
  decodeToken,
};
