const request = require('supertest');
const async = require('async');

describe('POST /containerDetails', function () {
	it('should get container details from id', function (done) {
		async.series(
			[
				function (callback) {
					request('http://localhost:8080')
						.post('/api/container/details')
						.set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({'containerId': '1234'})
            .expect(200, callback)
				}
			],
			done
		)
	}),
	it('should not get container details from wrong id', function (done) {
		async.series(
			[
				function (callback) {
					request('http://localhost:8080')
						.post('/api/container/details')
						.set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({'containerId': 'wrong id'})
            .expect(401, callback)
				}
			],
			done
		)
	}),
	it('should not get container details from empty id', function (done) {
		async.series(
			[
				function (callback) {
					request('http://localhost:8080')
						.post('/api/container/details')
						.set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({'containerId': ''})
            .expect(401, callback)
				}
			],
			done
		)
	}),
	it('should not get container details from null id', function (done) {
		async.series(
			[
				function (callback) {
					request('http://localhost:8080')
						.post('/api/container/details')
						.set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({'containerId': null})
            .expect(401, callback)
				}
			],
			done
		)
	})
})