const request = require('supertest');
const app = require('../server');

describe('API Contact Endpoint', () => {
  it('devrait enregistrer un nouveau contact avec des données valides', async () => {
    const contactData = {
      name: 'test',
      email: 'test@test.com',
      message: 'test',
    };

    const response = await request(app)
      .post('/api/contact')
      .send(contactData);

    expect(response.status).toBe(201);
    expect(response.body).toHaveProperty('message', 'contact saved');
  });

  it('devrait renvoyer une erreur avec des données invalides', async () => {
    const invalidData = {};

    const response = await request(app)
      .post('/api/contact')
      .send(invalidData);

    expect(response.status).toBe(401);
  });
});
