KS.Component = class {
  constructor(element) {
    this.$element = $(element);
  }

  destroy() {
    this.unbindEvents();
  }

  bindEvents() {}
  unbindEvents() {}
};
