const express = require('express')

const router = express.Router()
const passport = require('passport')
const userCtrl = require("../../controllers/Mobile/user")
const itemCtrl = require("../../controllers/Common/items")
const favoriteCtrl = require("../../controllers/Mobile/favorites")

router.post('/:itemId',
	passport.authenticate('jwt', { session: false}), async (req, res) => {
		try {
			if (!req.user) {
				return res.status(401).send('Invalid token')
			}
			const user = await userCtrl.findUserById(req.user.id)
			if (!user) {
				return res.status(401).send('User not found')
			}
			if (!req.params.itemId) {
				return res.status(401).send('Missing itemId')
			}
			const item = await itemCtrl.getItemFromId(req.params.itemId)
			if (!item) {
				return res.status(401).send('Item not found')
			}
			const favorite = await favoriteCtrl.checkFavorite(user.id, item.id)
			if (favorite) {
				return res.status(401).send('Favorite already existing')
			}
			await favoriteCtrl.createFavoriteItem(user.id, item.id)

			return res.status(201).json({ message: 'Favorite added' })
		} catch (err) {
			console.error(err.message)
			return res.status(401).send('An error occurred')
		}
	}
)

router.get('/',
	passport.authenticate('jwt', { session: false}), async (req, res) => {
		try {
			if (!req.user) {
				return res.status(401).send('Invalid token')
			}
			const user = await userCtrl.findUserById(req.user.id)
			if (!user) {
				return res.status(401).send('User not found')
			}

			const favorites = await favoriteCtrl.getUserFavorites(user.id)
			if (!favorites) {
				return res.status(401).send('Favorites not found')
			}

			return res.status(200).json({ favorites })
		} catch (err) {
			console.error(err.message)
			return res.status(401).send('An error occurred')
		}
	}
)

router.get('/:itemId',
	passport.authenticate('jwt', { session: false}), async (req, res) => {
		try {
			if (!req.user) {
				return res.status(401).send('Invalid token')
			}
			const user = await userCtrl.findUserById(req.user.id)
			if (!user) {
				return res.status(401).send('User not found')
			}
			if (!req.params.itemId) {
				return res.status(401).send('Missing itemId')
			}
			const item = await itemCtrl.getItemFromId(req.params.itemId)
			if (!item) {
				return res.status(401).send('Item not found')
			}
			const favorite = await favoriteCtrl.checkFavorite(user.id, item.id)

			return res.status(200).json(favorite)
		} catch (err) {
			console.error(err.message)
			return res.status(401).send('An error occurred')
		}
	}
)

router.delete('/:itemId',
	passport.authenticate('jwt', { session: false}), async (req, res) => {
		try {
			if (!req.user) {
				return res.status(401).send('Invalid token')
			}
			const user = await userCtrl.findUserById(req.user.id)
			if (!user) {
				return res.status(401).send('User not found')
			}
			if (!req.params.itemId) {
				return res.status(401).send('Missing itemId')
			}
			const item = await itemCtrl.getItemFromId(req.params.itemId)
			if (!item) {
				return res.status(401).send('Item not found')
			}
			const favorite = await favoriteCtrl.getItemFavorite(user.id, item.id)
			if (!favorite) {
				return res.status(401).send('Favorite not found')
			}
			await favoriteCtrl.deleteFavorite(favorite.id)

			return res.status(200).json({ message: 'Favorite deleted' })
		} catch (err) {
			console.error(err.message)
			return res.status(401).send('An error occurred')
		}
	}
)

module.exports = router