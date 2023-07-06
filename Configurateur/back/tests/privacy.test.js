const request = require('supertest');
const express = require('express');

const app = express();
const router = require('../routes/user.js');
app.use(router);

describe('GET /privacy', () => {
  it('should return privacy details', async () => {
    const response = await request(app).get('/privacy');
    expect(response.status).toBe(200);
    expect(response.text).toBe('Lorem ipsum dolor sit amet, consectetur adipiscing elit.');
  });
});