declare namespace Cypress {
    interface Chainable {
      getByDataTestId(value: string): any;
      containsText(value: string): any;
      doClick(): any;
    }
  }