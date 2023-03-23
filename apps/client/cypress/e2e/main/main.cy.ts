import { Epic, Feature, Story } from '../../support/allure-test-structure';
import {
  description,
  issue,
  owner,
  step,
  tag,
  testStructure,
} from '../../support/allure-commands';

describe('Первый набор тестов', () => {
  beforeEach(() => {
    testStructure(Epic.Name, Feature.FirstScreen, Story.FirstStory);
    owner('60126579');
    tag('auto');

    cy.visit('/');
  });

  it('Первый тест', () => {
    description('Описание');
    issue('POF-716', 'https://jira.lmru.tech/browse/POF-716');

    step('Первый шаг');
    cy.getByDataTestId('button').should('be.visible').doClick();
  });
});
