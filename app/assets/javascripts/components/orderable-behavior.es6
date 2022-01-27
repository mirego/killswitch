import Component from 'components/component';

class OrderableBehavior extends Component {
  constructor(element) {
    super(element);

    this.toggleElement = this.$element.find('a.toggle');
    sortable(this.$element);
    this.bindEvents();
  }

  bindEvents() {
    this.$element.on('sortupdate.OrderableBehavior', () => this.handleUpdate());
    this.toggleElement.on('click.OrderableBehavior', (event) =>
      this.handleDataToggle(event)
    );
  }

  unbindEvents() {
    this.$element.off('sortupdate.OrderableBehavior');
    this.toggleElement.off('click.OrderableBehavior');
  }

  handleUpdate() {
    const mapId = (_, element) => {
      return $(element).data('id');
    };
    const behaviorIds = this.$element.children().map(mapId).toArray();
    const url = this.$element.data('order-url');

    const data = {behaviors: behaviorIds};
    $.ajax({type: 'PUT', url, data});
  }

  handleDataToggle(event) {
    $(event.target).closest('li').find('.data-row').toggle();
  }
}

export default OrderableBehavior;
