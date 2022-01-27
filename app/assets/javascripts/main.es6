import App from 'components/app';
import OrderableBehavior from 'components/orderable-behavior';
import BehaviorPopulateDropdown from 'components/behavior-populate-dropdown';
import WaitingBar from 'components/waiting-bar';

$(() => {
  // Initialize application components
  window.App = new App();
  window.App.registerComponent(OrderableBehavior, '.behaviors-list')
    .registerComponent(BehaviorPopulateDropdown, '.behavior-populate')
    .registerComponent(WaitingBar, '.waiting-bar')
    .initialize();
});
