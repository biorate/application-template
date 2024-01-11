import { expect, step, Scenario } from '@biorate/playwright';

export class Scenario2 extends Scenario {
  @step()
  protected async step1() {
    await this.page.goto('https://playwright.dev/');
  }

  @step()
  protected async step2() {
    await expect(this.page).toHaveTitle(/Playwright/);
  }
}
