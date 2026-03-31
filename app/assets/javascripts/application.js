// = require ./namespace
// = require ./components/component
// = require ./components/app
// = require ./components/orderable-behavior
// = require ./components/behavior-populate-dropdown
// = require ./components/waiting-bar

$(() => {
  window.App = new KS.App();
  window.App.registerComponent(KS.OrderableBehavior, '.behaviors-list')
    .registerComponent(KS.BehaviorPopulateDropdown, '.behavior-populate')
    .registerComponent(KS.WaitingBar, '.waiting-bar')
    .initialize();
});
