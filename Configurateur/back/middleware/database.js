require('dotenv').config({ path: '../.env' })
const { PrismaClient } = require('@prisma/client')
const db = new PrismaClient()

module.exports = { db }
