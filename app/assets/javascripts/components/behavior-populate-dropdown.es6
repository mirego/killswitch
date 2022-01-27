import Component from 'components/component';

class BehaviorPopulateDropdown extends Component {
  constructor(element) {
    super(element);
    this.linkElements = this.$element.find('a');
    this.textField = this.$element
      .closest('.btn-group')
      .siblings('textarea, input:text');
    this.bindEvents();
  }

  bindEvents() {
    this.linkElements.on('click.BehaviorPopulateDropdown', (event) =>
      this.handleClick(event)
    );
  }

  unbindEvents() {
    this.linkElements.off('click.BehaviorPopulateDropdown');
  }

  handleClick(event) {
    const $target = $(event.currentTarget);
    const templateAsObject = JSON.parse($target.attr('data-template'));
    const templateAsPrettyString = JSON.stringify(
      templateAsObject,
      undefined,
      2
    );

    this.textField.val(templateAsPrettyString);
  }
}

export default BehaviorPopulateDropdown;
