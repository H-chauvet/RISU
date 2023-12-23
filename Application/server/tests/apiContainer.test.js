const request = require('supertest');
const async = require('async');
const { json } = require('express');

describe('POST /containerDetails', () => {
	var containersId = []
	beforeAll(async () => {
		const response = await request('http://localhost:8080')
			.get('/api/container/listall')
			.set('Content-Type', 'application/json')
			.set('Accept', 'application/json')
		containersId[0] = response.body[0].id
	})
	it('should get container details from id', function (done) {
		async.series(
			[
				function (callback) {
					request('http://localhost:8080')
						.post('/api/container/details')
						.set('Content-Type', 'application/json')
						.set('Accept', 'application/json')
						.send({ 'containerId': containersId[0] })
						.expect(200, callback)
				}
			],
			done
		)
	})
	it('should not get container details from wrong id', function (done) {
		async.series(
			[
				function (callback) {
					request('http://localhost:8080')
						.post('/api/container/details')
						.set('Content-Type', 'application/json')
						.set('Accept', 'application/json')
						.send({ 'containerId': 'wrong id' })
						.expect(401, callback)
				}
			],
			done
		)
	})
	it('should not get container details from empty id', function (done) {
		async.series(
			[
				function (callback) {
					request('http://localhost:8080')
						.post('/api/container/details')
						.set('Content-Type', 'application/json')
						.set('Accept', 'application/json')
						.send({ 'containerId': '' })
						.expect(401, callback)
				}
			],
			done
		)
	})
	it('should not get container details from null id', function (done) {
		async.series(
			[
				function (callback) {
					request('http://localhost:8080')
						.post('/api/container/details')
						.set('Content-Type', 'application/json')
						.set('Accept', 'application/json')
						.send({ 'containerId': null })
						.expect(401, callback)
				}
			],
			done
		)
	})
})
