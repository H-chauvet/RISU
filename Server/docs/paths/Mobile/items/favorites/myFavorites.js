module.exports = {
  get: {
    tags: ["Mobile", "Rent"],
    summary: 'get all the favorite of an user',
    description: 'Retrieve all the favorites datas and an access to their item',
    operationId: "mobileGetFavorites",
    consumes: ["application/json"],
    produces: ["application/json"],
    parameters: [
      {
        name: 'token',
        description: 'the token of the user',
        in: 'body',
        type: "string"
      },
    ],
    responses: {
      200: {
        description: 'OK',
        content: {
          "application/json": {
            schema: {
              $ref: "#/components/schemas/Favorite_Article_Mobile"
            }
          }
        }
      },
      401: {
        description: 'An Error occured',
        content : {
          "application/json": {
              example: "Favorites not found"
          }
        }
      }
    }
  }
}