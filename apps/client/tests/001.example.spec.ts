import { Severity } from 'allure-js-commons';
import {
  suite,
  test,
  issue,
  severity,
  epic,
  feature,
  story,
  owner,
  tag,
  Page,
  expect,
} from '@biorate/playwright';
import { Spec } from './spec';

@suite('Test')
class Test extends Spec {
  @issue('1')
  @severity(Severity.MINOR)
  @epic('Epic allure test1')
  @feature('Feature allure test1')
  @story('Story allure test1')
  @owner('60000000')
  @tag('tag1')
  @test('test1')
  protected async test1({ page }: { page: Page }) {
    await page.goto('https://playwright.dev/');
    await expect(page).toHaveTitle(/Playwright/);
  }

  @issue('2')
  @severity(Severity.MINOR)
  @epic('Epic allure test2')
  @feature('Feature allure test2')
  @story('Story allure test2')
  @owner('60000000')
  @tag('tag2')
  @test('test2')
  protected async test2({ page }: { page: Page }) {
    await page.goto('https://playwright.dev/');
    await expect(page).toHaveTitle(/Playwright/);
  }
}
