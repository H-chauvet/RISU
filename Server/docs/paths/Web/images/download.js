module.exports = {
    post: {
      tags: ["Web", "Image"],
      summary: 'Download an image from the S3 bucket',
      description: 'Download an image from the S3 bucket',
      operationId: "WebImageDownload",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'id',
          in: 'params',
          type: "integer",
          description : "Id of the item"
        },

      ],
      responses: {
        200: {
          description: 'List of images URLs'
        }
      }
    }
  }
