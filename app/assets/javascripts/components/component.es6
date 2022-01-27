class Component {
  constructor(element) {
    this.$element = $(element);
  }

  destroy() {
    this.unbindEvents();
  }

  bindEvents() {}
  unbindEvents() {}
}

export default Component;
