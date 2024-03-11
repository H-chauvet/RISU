const mobileSignUp = require('./Mobile/auth/signup')
const mobileLogIn = require('./Mobile/auth/login')
const mobileMailVerification = require('./Mobile/auth/mailVerification')
const mobileContact = require('./Mobile/contact/contact')
const mobileContainerListAll = require('./Mobile/container/listAll')
const mobileContainerId = require('./Mobile/container/containerId')
const mobileContainerArticleList = require('./Mobile/container/articleList')
const mobileItemListAll = require('./Mobile/items/listAll')
const mobileItemId = require('./Mobile/items/itemId')
const mobileOpinion = require('./Mobile/opinion/opinion')
const mobileRentArticle = require('./Mobile/rent/article')
const mobileRentListAll = require('./Mobile/rent/listAll')
const mobileRentId = require('./Mobile/rent/rentId')
const mobileRentReturn = require('./Mobile/rent/returnRent')
const mobileUserListAll = require('./Mobile/user/listAll')
const mobileUserPassword = require('./Mobile/user/password')
const mobileUserResetPassword = require('./Mobile/user/resetPassword')
const mobileUserUpdate = require('./Mobile/user/update')
const mobileUserId = require('./Mobile/user/userId')

module.exports = {
    paths: {
        '/api/mobile/auth/signup': {
            ...mobileSignUp
        },
        '/api/mobile/auth/login': {
            ...mobileLogIn
        },
        '/api/mobile/auth/mailVerification': {
            ...mobileMailVerification
        },
        '/api/mobile/contact': {
            ...mobileContact
        },
        '/api/mobile/container/listAll': {
            ...mobileContainerListAll
        },
        '/api/mobile/container/:containerId': {
            ...mobileContainerId
        },
        '/api/mobile/container/:containerId/articlelist': {
            ...mobileContainerArticleList
        },
        '/api/mobile/article/listAll': {
            ...mobileItemListAll
        },
        '/api/mobile/article/:articleId': {
            ...mobileItemId
        },
        '/api/mobile/opinion/': {
            ...mobileOpinion
        },
        '/api/mobile/rent/article': {
            ...mobileRentArticle
        },
        '/api/mobile/rent/listAll': {
            ...mobileRentListAll
        },
        '/api/mobile/rent/:rentId': {
            ...mobileRentId
        },
        '/api/mobile/rent/:rentId/return': {
            ...mobileRentReturn
        },
        '/api/mobile/user/listAll': {
            ...mobileUserListAll
        },
        '/api/mobile/user/password': {
            ...mobileUserPassword
        },
        '/api/mobile/user/resetPassword': {
            ...mobileUserResetPassword
        },
        '/api/mobile/user/:userId': {
            ...mobileUserId
        },
        '/api/mobile/user/': {
            ...mobileUserUpdate
        },
        // '/api/contact': {
        //     ...mobileSignUp
        // },
        // '/api/container/get': {
        //     ...mobileSignUp
        // },
        // '/api/container/delete': {
        //     ...mobileSignUp
        // },
        // '/api/container/create': {
        //     ...mobileSignUp
        // },
        // '/api/container/update': {
        //     ...mobileSignUp
        // },
        // '/api/container/listAll': {
        //     ...mobileSignUp
        // },
        // '/api/feedbacks/create': {
        //     ...mobileSignUp
        // },
        // '/api/feedbacks/listAll': {
        //     ...mobileSignUp
        // },
        // '/api/items/listAll': {
        //     ...mobileSignUp
        // },
        // '/api/items/create': {
        //     ...mobileSignUp
        // },
        // '/api/items/delete': {
        //     ...mobileSignUp
        // },
        // '/api/items/update': {
        //     ...mobileSignUp
        // },
        // '/api/messages/list': {
        //     ...mobileSignUp
        // },
        // '/api/messages/delete': {
        //     ...mobileSignUp
        // },
        // '/api/payment/card-pay': {
        //     ...mobileSignUp
        // },
        // '/api/auth/login': {
        //     ...mobileSignUp
        // },
        // '/api/auth/google-login': {
        //     ...mobileSignUp
        // },
        // '/api/auth/register': {
        //     ...mobileSignUp
        // },
        // '/api/auth/forgot-password': {
        //     ...mobileSignUp
        // },
        // '/api/auth/update-password': {
        //     ...mobileSignUp
        // },
        // '/api/auth/register-confirmation': {
        //     ...mobileSignUp
        // },
        // '/api/auth/confirmed-register': {
        //     ...mobileSignUp
        // },
        // '/api/auth/privacy': {
        //     ...mobileSignUp
        // },
        // '/api/auth/listAll': {
        //     ...mobileSignUp
        // },
        // '/api/auth/update-details/:email/': {
        //     ...mobileSignUp
        // },
        // '/api/auth/update-mail': {
        //     ...mobileSignUp
        // },
        // '/api/auth/update-company/:email': {
        //     ...mobileSignUp
        // },
        // '/api/auth/update-password/:email': {
        //     ...mobileSignUp
        // },
    }
}