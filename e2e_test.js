'use strict';
const test = require('tape')
const got = require('got')

const setup = () => {
  const fixtures = {}
  if (process.argv.length > 3) {
    const addr = process.argv[3]
    if (addr.indexOf(':') > 0) {
      fixtures.addr = addr;
    }
  }
  return fixtures
}

const teardown = (fixtures) => {
  // do nothing
}

test('/numbers with valid limit', (t) => {
  const fixtures = setup()
  t.ok(fixtures.addr, 'Valid target address (pass by cli argument)')

  const cases = [
    { limit: 7, out: [0, 1, 1, 2, 3, 5, 8] },
    { limit: 3, out: [0, 1, 1] },
    { limit: 0, out: [] },
  ]

  cases.forEach((c) => {
    t.test(`test with limit ${c.limit}`, (t) => {
      got(`${fixtures.addr}/numbers`, { query:{ limit: c.limit }, json: true })
        .then((response) => {
          t.same(response.body, c.out)
        })
        .catch((err) => {
          t.error(err, 'Unexpected error')
        })
        .then(teardown(fixtures))
        .then(t.end())
    })
  })

  teardown(fixtures)
  t.end()
});

test('/numbers with invalid limit', (t) => {
  const fixtures = setup()
  t.ok(fixtures.addr, 'Valid target address (pass by cli argument)')

  const cases = ['a', 'asdf', 'u89', -1, -3, -10]

  cases.forEach((c) => {
    t.test(`test with limit ${c}`, (t) => {
      got(`${fixtures.addr}/numbers`, { query:{ limit: c }, json: true })
        .then((response) => {
          t.fail('Should not enter this block')
        })
        .catch((err) => {
          t.equal(err.statusCode, 400)
        })
        .then(teardown(fixtures))
        .then(t.end())
    })
  })

  teardown(fixtures)
  t.end()
})

test('/numbers with valid index', (t) => {
  const fixtures = setup()
  t.ok(fixtures.addr, 'Valid target address (pass by cli argument)')

  const cases = [0, 1, 1, 2, 3, 5, 8]

  cases.forEach((v, i) => {
    t.test(`test with index ${i}`, (t) => {
      got(`${fixtures.addr}/numbers/${i}`, { json: true })
        .then((response) => {
          t.same(response.body, v)
        })
        .catch((err) => {
          t.error(err, 'Unexpected error')
        })
        .then(teardown(fixtures))
        .then(t.end())
    })
  })

  teardown(fixtures)
  t.end()
})

test('/numbers with invalid index', (t) => {
  const fixtures = setup()
  t.ok(fixtures.addr, 'Valid target address (pass by cli argument)')

  const cases = [-1, -2, 'asd', 'w']

  cases.forEach((c) => {
    t.test(`test with index ${c}`, (t) => {
      got(`${fixtures.addr}/numbers/${c}`, { json: true })
        .then((response) => {
          t.fail('Should not enter this block')
        })
        .catch((err) => {
          t.equal(err.statusCode, 400)
        })
        .then(teardown(fixtures))
        .then(t.end())
    })
  })

  teardown(fixtures)
  t.end()
})
