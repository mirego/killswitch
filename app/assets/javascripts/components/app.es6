class App {
  constructor() {
    this.registeredComponents = [];
    this.instanciatedComponents = [];
    this.$self = $(this);

    const dispatchUnloadEvent = function () {
      const event = document.createEvent('Events');
      event.initEvent('turbolinks:unload', true, false);
      document.dispatchEvent(event);
    };

    document.addEventListener('beforeunload', dispatchUnloadEvent);
    document.addEventListener('turbolinks:before-render', dispatchUnloadEvent);

    window.$window = $(window);
    window.$document = $(document);
    window.$document.on('turbolinks:load', () => this.pageDidLoad());
    window.$document.on('turbolinks:unload', () => this.pageWillUnload());
  }

  initialize() {
    this.instanciateComponents();
    return this;
  }

  pageDidLoad() {
    this.instanciateComponents();
  }

  pageWillUnload() {
    this.destroyComponents();
  }

  registerComponent(componentClass, componentSelector) {
    this.registeredComponents.push({
      class: componentClass,
      selector: componentSelector,
      arguments:
        arguments.length > 2 ? Array.prototype.slice.call(arguments, 2) : null
    });

    return this;
  }

  instanciateComponents() {
    this.registeredComponents.forEach((component) => {
      const components = $(component.selector)
        .toArray()
        .map((element) => {
          const constructor = component.class;
          if (component.arguments) {
            component.arguments.unshift(element);

            const F = function () {
              return constructor.apply(this, component.arguments);
            };
            F.prototype = constructor.prototype;
            return new F();
          } else {
            return new constructor(element);
          }
        });

      this.instanciatedComponents =
        this.instanciatedComponents.concat(components);
    });

    return this;
  }

  destroyComponents() {
    this.instanciatedComponents.forEach((component) => component.destroy());
    this.instanciatedComponents.splice(0, this.instanciatedComponents.length);
    return this;
  }
}

export default App;
