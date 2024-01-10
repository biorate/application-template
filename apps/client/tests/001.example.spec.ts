import { Severity, ContentType } from 'allure-js-commons';
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
  description,
  expect,
  allure,
} from '@biorate/playwright';
import { Spec } from './common/spec';

@suite('Test')
class Test extends Spec {
  protected static async after() {
    allure.attachment('Test attachment', 'test attachment content', ContentType.TEXT);
  }

  @issue('1')
  @severity(Severity.MINOR)
  @epic('Epic allure test1')
  @feature('Feature allure test1')
  @story('Story allure test1')
  @description('Playwright page test')
  @owner('60000000')
  @tag('tag1')
  @test('test1')
  protected async test1({ page }: { page: Page }) {
    allure.logStep('test1 starts');
    await page.goto('https://playwright.dev/');
    allure.attachment('Playwright test', 'Playwright test content', ContentType.TEXT);
    const screenshot = await page.screenshot();
    allure.attachment('Screenshot', screenshot, ContentType.PNG);
    await expect(page).toHaveTitle(/Playwright/);
    allure.logStep('test1 finished');
  }

  @issue('2')
  @severity(Severity.MINOR)
  @epic('Epic allure test2')
  @feature('Feature allure test2')
  @story('Story allure test2')
  @description('Google page test')
  @owner('60000000')
  @tag('tag2')
  @test('test2')
  protected async test2({ page }: { page: Page }) {
    await page.goto('https://google.com/');
    allure.attachment('Google test', 'Google test content', ContentType.TEXT);
    await expect(page).toHaveTitle(/Google/);
  }
}
