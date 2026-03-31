KS.WaitingBar = class extends KS.Component {
  constructor(element) {
    super(element);
    this.bindEvents();
  }

  bindEvents() {
    window.$document.on('page:fetch.WaitingBar', () => this.handlePageFetch());
  }

  unbindEvents() {
    window.$document.off('page:fetch.WaitingBar');
  }

  handlePageFetch() {
    this.$element.show();
  }
};
