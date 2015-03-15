class App.Routers.AppRouter extends Backbone.Router
  initialize: (options) ->
    Backbone.history.start
      pushState: true

  routes:
    "my-home" : "myHome"
    "causes-preferences-causes" : "causesPreferencesCauses"
    "causes-preferences-places" : "causesPreferencesPlaces"
    "causes-preferences-interests" : "causesPreferencesInterests"
    "causes-preferences-collect" : "causesPreferencesCollect"
    "charities/dashboard/current-status" : "charitiesDashboardCurrentStatus"
    "charities/dashboard/approvals-new-staff" : "charitiesDashboardApprovalsNewStaff"
    "checkout" : "checkout"
    "checkout/:id" : "checkout"
    "payment" : "payment"
    "charities/:name" : "charity"
    "projects/:name" : "project"
    "charities/:charity_id/projects/new" : "newProject"
    "charities/:charity_id/projects/:id/edit" : "editProject"
    "users/:name" : "user"
    "users/:name/edit" : "user"

  myHome: ->
    @updatesView ||= new App.Views.UpdatesView() # we have updates in this view
    $('#followings').hide() if $('#followings #content:contains(No update yet)').length > 0

  charitiesDashboardCurrentStatus: ->
    @charitiesDashboard()

  charitiesDashboardApprovalsNewStaff: ->
    @charitiesDashboard()
    @charitiesDashboardApprovalsNewStaffView ||= new App.Views.CharitiesDashboardApprovalsNewStaffView()

  charitiesDashboard: ->
    @charitiesDashboardView ||= new App.Views.CharitiesDashboardView()

  causesPreferencesCauses: ->
    @causesPreferences()
    @causesPreferencesCausesView ||= new App.Views.CausesPreferencesCausesView()

  causesPreferencesPlaces: ->
    @causesPreferences()
    @causesPreferencesPlacesView ||= new App.Views.CausesPreferencesPlacesView()

  causesPreferencesInterests: ->
    @causesPreferences()
    @causesPreferencesInterestsView ||= new App.Views.CausesPreferencesInterestsView()

  causesPreferencesCollect: ->
    @causesPreferences()
    @causesPreferencesCollectView ||= new App.Views.CausesPreferencesCollectView()

  causesPreferences: ->
    @causesPreferencesView ||= new App.Views.CausesPreferencesView()

  checkout: (id = null) ->
    @checkoutPaymentConfirmation()
    @checkoutView ||= new App.Views.CheckoutView()

  payment: ->
    @checkoutPaymentConfirmation()
    @paymentView ||= new App.Views.PaymentView()

  checkoutPaymentConfirmation: ->
    @checkoutPaymentConfirmationView ||= new App.Views.CheckoutPaymentConfirmationView()

  charity: (name) ->
    @charityView ||= new App.Views.CharityView()
    @updatesView ||= new App.Views.UpdatesView() # we have updates in this view

  saveProject: ->
    @saveProjectView ||= new App.Views.SaveProjectView()

  newProject: (charityId) ->
    @saveProject()
    @newProjectView ||= new App.Views.NewProjectView()

  editProject: (charityId, project_id) ->
    @saveProject()
    @editProjectView ||= new App.Views.EditProjectView()
    @newProjectView.undelegateEvents() if @newProjectView

  project: (name) ->
    @projectView ||= new App.Views.ProjectView()

  user: (name) ->
    @userView ||= new App.Views.UserView()
    @updatesView ||= new App.Views.UpdatesView() # we have updates in this view
