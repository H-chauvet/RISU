module.exports = {
  post: {
    summary: 'Send a verification mail to the new user',
    description: 'Send a verification mail to the new user',
    parameters: [
      {
        name: 'email',
        in: 'body',
        schema: {
          $ref: '#/components/schemas/User'
        }
      }
    ],
    responses: {
      200: {
        description: 'OK'
      },
      400: {
        description: 'Invalid parameters'
      }
    }
  }
}
