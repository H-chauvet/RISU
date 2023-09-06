module.exports = {
  post: {
    summary: 'Send a new password mail to the user',
    description: 'Send a new password mail to the user',
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
