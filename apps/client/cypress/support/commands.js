// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add('login', (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add('drag', { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add('dismiss', { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite('visit', (originalFn, url, options) => { ... })

Cypress.Commands.add('getByDataTestId', (selector) => {
  cy.allure().logStep(`Найти элемент data-testid="${selector}" найден`);
  return cy.get(`[data-testid=${selector}]`);
});

Cypress.Commands.add('containsText', { prevSubject: true }, (subject, text) => {
  const object = cy.wrap(subject, { log: true });
  cy.allure().logStep(`Он содержит текст "${text}"`);
  return object.contains(text);
});

Cypress.Commands.add('doClick', { prevSubject: true }, (subject) => {
  const object = cy.wrap(subject, { log: true });
  cy.allure().logStep(`Кликнуть по этому элементу`);
  return object.click();
});
