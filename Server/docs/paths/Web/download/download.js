module.exports = {
    get: {
      tags: ["Web", "Download"],
      summary: 'Download the client APK',
      description: 'Allows the user to download the client APK file',
      operationId: "DownloadClientAPK",
      produces: ["application/octet-stream"],
      responses: {
        200: {
          description: 'File downloaded successfully',
          content: {
            "application/octet-stream": {
              example: "Binary data of the client.apk file"
            }
          }
        },
        500: {
          description: 'Internal server error',
          content: {
            "application/json": {
              example: "Error during file download"
            }
          }
        }
      }
    }
  }
  