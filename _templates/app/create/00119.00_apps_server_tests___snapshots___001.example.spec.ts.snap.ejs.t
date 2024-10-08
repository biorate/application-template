---
to: <%= h.server(CUT_EXAMPLES || `${ROOT}/apps/${SERVER_NAME}/tests/__snapshots__/001.example.spec.ts.snap`) %>
unless_exists: true
---
// Jest Snapshot v1, https://goo.gl/fbAQLP

exports[`Example Negative unit test 1`] = `Array []`;

exports[`Example Negative unit test 2`] = `
Test {
  "dec": 1,
  "inc": 5,
}
`;

exports[`Example Unit test 1 1`] = `
Array [
  Object {
    "inc": 1,
  },
]
`;

exports[`Example Unit test 1 2`] = `2`;

exports[`Example Unit test 1 3`] = `1`;

exports[`Example Unit test 1 4`] = `3`;

exports[`Example Unit test 1 5`] = `1`;

exports[`Example Unit test 1 6`] = `
Array [
  Object {
    "inc": 2,
  },
]
`;

exports[`Example Unit test 1 7`] = `3`;

exports[`Example Unit test 2 1`] = `
Array [
  Object {
    "inc": 1,
  },
]
`;

exports[`Example Unit test 2 2`] = `
Test {
  "dec": 1,
  "inc": 3,
}
`;

exports[`Example Unit test 2 3`] = `
Test {
  "dec": 1,
  "inc": 4,
}
`;

exports[`Example Unit test 2 4`] = `
Array [
  Object {
    "inc": 2,
  },
]
`;

exports[`Example Unit test 2 5`] = `4`;

exports[`Example Unit test 3 1`] = `
Array [
  Object {
    "inc": 1,
  },
]
`;

exports[`Example Unit test 3 2`] = `
Test {
  "dec": 1,
  "inc": 4,
}
`;

exports[`Example Unit test 3 3`] = `
Test {
  "dec": 1,
  "inc": 5,
}
`;

exports[`Example Unit test 3 4`] = `
Array [
  Object {
    "inc": 2,
  },
]
`;

exports[`Example Unit test 3 5`] = `5`;
