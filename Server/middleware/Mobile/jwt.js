const jwt = require("jsonwebtoken");
const crypto = require("crypto");

/**
 * Generate token
 *
 * @param {*} user user object
 * @returns generated token
 */
function generateToken(id) {
  return jwt.sign({ id }, process.env.JWT_ACCESS_SECRET, {
    expiresIn: parseInt(process.env.JWT_EXPIRE)
  });
}

module.exports = {
  generateToken,
};
