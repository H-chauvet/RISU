const jwt = require("jsonwebtoken");
const crypto = require("crypto");

/**
 * Generate token
 *
 * @param {*} user user object
 * @returns generated token
 */
function generateToken(id, longTerm = false) {
  const expireInSeconds = longTerm ? parseInt(process.env.REFRESH_JWT_EXPIRE) : parseInt(process.env.JWT_EXPIRE);
  console.log(parseInt(process.env.REFRESH_JWT_EXPIRE))
  console.log(parseInt(process.env.JWT_EXPIRE))
  console.log('expireInSeconds', expireInSeconds);
  return jwt.sign({ id }, process.env.JWT_ACCESS_SECRET, {
    expiresIn: expireInSeconds
  });
}

/**
 * Generate refresh token
 *
 * @param {*} user user object
 * @returns generated refresh token
 */
function generateRefreshToken(id) {
  return crypto.randomBytes(64).toString('hex');
}

module.exports = {
  generateToken,
  generateRefreshToken
};
