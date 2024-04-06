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

/**
 * Middleware to refresh token if expired
 *
 * @param {*} req Express request object
 * @param {*} res Express response object
 * @param {*} next Next middleware function
 */
const refreshTokenMiddleware = async (req, res, next) => {
  try {
    if (!req.headers.authorization) {
      return next();
    }
    const token = req.headers.authorization.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_ACCESS_SECRET);

    const currentTimestamp = Math.floor(Date.now() / 1000);
    if (decoded.exp < currentTimestamp) {
      const userId = decoded.id;
      const newToken = generateToken(userId);

      res.setHeader('Authorization', `Bearer ${newToken}`);
    }
    next();
  } catch (err) {
    console.error('Error in refreshTokenMiddleware:', err.message);
    next(err);
  }
};

module.exports = {
  generateToken,
  generateRefreshToken,
  refreshTokenMiddleware
};
