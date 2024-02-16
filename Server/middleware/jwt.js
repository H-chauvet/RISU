const jwt = require("jsonwebtoken");
const crypto = require("crypto");

/**
 *
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
 *
 * Encrypt token
 *
 * @param {*} token generated token
 * @returns encrypted toked
 */
function hashToken(token) {
  return crypto.createHash("sha512").update(token).digest("hex");
}

function verifyToken(token) {
  return jwt.verify(token, process.env.JWT_ACCESS_SECRET);
}

module.exports = {
  generateAccessToken,
  hashToken,
  verifyToken,
};
