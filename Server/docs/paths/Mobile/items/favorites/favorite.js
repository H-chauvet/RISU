module.exports = {
  get: {
    tags: ["Mobile", "Rent"],
    summary: 'check if an article is a favorite for the connected user',
    description: 'Retrieve a boolean thanks to an itemId and the id of the connected user',
    operationId: "mobileCheckFavorite",
    consumes: ["application/json"],
    produces: ["application/json"],
    parameters: [
      {
        name: 'token',
        description: 'the token of the user',
        in: 'body',
        type: "string"
      },
      {
          name: 'itemId',
          description: 'the id of the searched item',
          in: 'body',
          type: "string"
      },
    ],
    responses: {
      200: {
        description: 'OK',
        content: {
          "application/json": {
            type: "Boolean"
          }
        }
      },
      401: {
        description: 'An Error occured',
        content : {
          "application/json": {
              example: "Item not found"
          }
        }
      }
    }
  },
  post: {
    tags: ["Mobile", "Rent"],
    summary: "Add a favorite item for a user",
    description: "Add an item as favorite from its id for the connected user",
    operationId: "mobileCreateFavorite",
    consumes: ["application/json"],
    produces: ["application/json"],
    parameters: [
      {
        name: 'token',
        description: 'the token of the user',
        in: 'body',
        type: "string"
      },
      {
          name: 'itemId',
          description: 'the id of the searched item',
          in: 'body',
          type: "string"
      },
    ],
    responses: {
      200: {
        description: 'OK',
        content: {
          "application/json": {
            example: {
              message: "Favorite added"
            }
          }
        }
      },
      401: {
        description: 'An Error occured',
        content : {
          "application/json": {
              example: "Favorite already exist"
          }
        }
      }
    }
  },
  delete: {
    tags: ["Mobile", "Rent"],
    summary: "Add a favorite item for an user",
    description: "Add an item as favorite from its id for the connected user",
    operationId: "mobileDeleteFavorite",
    consumes: ["application/json"],
    produces: ["application/json"],
    parameters: [
      {
        name: 'token',
        description: 'the token of the user',
        in: 'body',
        type: "string"
      },
      {
          name: 'itemId',
          description: 'the id of the searched item',
          in: 'body',
          type: "string"
      },
    ],
    responses: {
      200: {
        description: 'OK',
        content: {
          "application/json": {
            example: {
              message: "Favorite deleted"
            }
          }
        }
      },
      401: {
        description: 'An Error occured',
        content : {
          "application/json": {
              example: "Favorite not found"
          }
        }
      }
    }
  }
}