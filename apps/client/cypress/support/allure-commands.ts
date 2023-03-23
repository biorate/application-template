export function step(text: string): void {
  cy.allure().step(text, true);
}

export function subStep(text: string): void {
  cy.allure().logStep(text);
}

export function description(text: string): void {
  cy.allure().description(text);
}

export function epic(text: string): void {
  cy.allure().epic(text);
}

export function feature(text: string): void {
  cy.allure().story(text);
}

export function story(text: string): void {
  cy.allure().story(text);
}

export function owner(text: string): void {
  cy.allure().owner(text);
}

export function tag(text: string): void {
  cy.allure().tag(text);
}

export function issue(name: string, url: string): void {
  cy.allure().issue(name, url);
}

export function testStructure(
  epicName: string,
  featurName: string,
  storyName: string,
): void {
  epic(epicName);
  feature(featurName);
  story(storyName);
}
