---
to: <%= h.server(CUT_EXAMPLES || `${ROOT}/apps/${SERVER_NAME}/tests/__snapshots__/00001.example.spec.ts.snap`) %>
unless_exists: true
---
// Vitest Snapshot v1, https://vitest.dev/guide/snapshot.html

exports[`Example > Negative unit test > [args before] doesn't equal in [error] method 1`] = `[]`;

exports[`Example > Negative unit test > [context before] doesn't equal in [error] method 1`] = `
Test {
  "dec": 1,
  "inc": 5,
}
`;

exports[`Example > Unit test 1 > [args after] doesn't equal in [mutate] method 1`] = `
[
  {
    "inc": 2,
  },
]
`;

exports[`Example > Unit test 1 > [args before] doesn't equal in [mutate] method 1`] = `
[
  {
    "inc": 1,
  },
]
`;

exports[`Example > Unit test 1 > [context after] doesn't equal in [mutate] method 1`] = `3`;

exports[`Example > Unit test 1 > [context after] doesn't equal in [mutate] method 2`] = `1`;

exports[`Example > Unit test 1 > [context before] doesn't equal in [mutate] method 1`] = `2`;

exports[`Example > Unit test 1 > [context before] doesn't equal in [mutate] method 2`] = `1`;

exports[`Example > Unit test 1 > [return] doesn't equal in [mutate] method 1`] = `3`;

exports[`Example > Unit test 2 > [args after] doesn't equal in [mutate] method 1`] = `
[
  {
    "inc": 2,
  },
]
`;

exports[`Example > Unit test 2 > [args before] doesn't equal in [mutate] method 1`] = `
[
  {
    "inc": 1,
  },
]
`;

exports[`Example > Unit test 2 > [context after] doesn't equal in [mutate] method 1`] = `
Test {
  "dec": 1,
  "inc": 4,
}
`;

exports[`Example > Unit test 2 > [context before] doesn't equal in [mutate] method 1`] = `
Test {
  "dec": 1,
  "inc": 3,
}
`;

exports[`Example > Unit test 2 > [return] doesn't equal in [mutate] method 1`] = `4`;

exports[`Example > Unit test 3 > [args after] doesn't equal in [mutate] method 1`] = `
[
  {
    "inc": 2,
  },
]
`;

exports[`Example > Unit test 3 > [args before] doesn't equal in [mutate] method 1`] = `
[
  {
    "inc": 1,
  },
]
`;

exports[`Example > Unit test 3 > [context after] doesn't equal in [mutate] method 1`] = `
Test {
  "dec": 1,
  "inc": 5,
}
`;

exports[`Example > Unit test 3 > [context before] doesn't equal in [mutate] method 1`] = `
Test {
  "dec": 1,
  "inc": 4,
}
`;

exports[`Example > Unit test 3 > [return] doesn't equal in [mutate] method 1`] = `5`;

