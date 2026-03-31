//= require ./components/component
//= require ./components/app
//= require ./components/orderable-behavior
//= require ./components/behavior-populate-dropdown
//= require ./components/waiting-bar

$(() => {
  window.App = new App();
  window.App.registerComponent(OrderableBehavior, '.behaviors-list')
    .registerComponent(BehaviorPopulateDropdown, '.behavior-populate')
    .registerComponent(WaitingBar, '.waiting-bar')
    .initialize();
});
