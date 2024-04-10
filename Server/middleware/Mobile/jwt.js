const jwt = require("jsonwebtoken");
const crypto = require("crypto");

/**
 * Generate token
 *
 * @param {*} id user id, longTerm: boolean to generate long term token
 * @returns generated token
 */
function generateToken(id, longTerm = false) {
  if (!process.env.REFRESH_JWT_EXPIRE) {
    throw new Error('REFRESH_JWT_EXPIRE not found in .env');
  } else if (!process.env.JWT_EXPIRE) {
    throw new Error('JWT_EXPIRE not found in .env');
  }
  const expireInSeconds = longTerm ? parseInt(process.env.REFRESH_JWT_EXPIRE) : parseInt(process.env.JWT_EXPIRE);
  return jwt.sign({ id }, process.env.JWT_ACCESS_SECRET, {
    expiresIn: expireInSeconds
  });
}

/**
 * Generate refresh token
 *
 * @param {*} id user id
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
    if (!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) {
      return next();
    }
    const token = req.headers.authorization.split(' ')[1];
    try {
      const decoded = jwt.verify(token, process.env.JWT_ACCESS_SECRET);
      const currentTimestamp = Math.floor(Date.now() / 1000);
      if (decoded.exp < currentTimestamp) {
        const userId = decoded.id;
        const newToken = generateToken(userId);
        res.setHeader('Authorization', `Bearer ${newToken}`);
      }
    } catch (err) {
      console.error('Error verifying token in refreshTokenMiddleware:', err.message);
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
