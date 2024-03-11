const mobileSignUp = require('./Mobile/auth/signup')
const mobileLogIn = require('./Mobile/auth/login')
const mobileMailVerification = require('./Mobile/auth/mailVerification')
const mobileContact = require('./Mobile/contact/contact')
const mobileContainerListAll = require('./Mobile/container/listAll')
const mobileContainerId = require('./Mobile/container/containerId')
const mobileContainerArticleList = require('./Mobile/container/articleList')

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
        // '/api/mobile/article/listAll': {
        //     ...mobileSignUp
        // },
        // '/api/mobile/article/:articleId': {
        //     ...mobileSignUp
        // },
        // '/api/mobile/opinion/': {
        //     ...mobileSignUp
        // },
        // '/api/mobile/rent/article': {
        //     ...mobileSignUp
        // },
        // '/api/mobile/rent/listAll': {
        //     ...mobileSignUp
        // },
        // '/api/mobile/rent/:rentId': {
        //     ...mobileSignUp
        // },
        // '/api/mobile/rent/:rentId/return': {
        //     ...mobileSignUp
        // },
        // '/api/mobile/user/listAll': {
        //     ...mobileSignUp
        // },
        // '/api/mobile/user/password': {
        //     ...mobileSignUp
        // },
        // '/api/mobile/user/resetPassword': {
        //     ...mobileSignUp
        // },
        // '/api/mobile/user/:userId': {
        //     ...mobileSignUp
        // },
        // '/api/mobile/user/': {
        //     ...mobileSignUp
        // },
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