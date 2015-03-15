class UserObserver < ActiveRecord::Observer
  def after_create(user)
    if Rails.env.production?
      tracker = Mixpanel::Tracker.new("62d6730610885a64e82331edffe9afae")
      tracker.track(0, 'Registration', {
          'Logged in type' => 'No',
          'Existing registration' => 'No',
          'Country' => '',
          'Date of action' => Time.now,
          'Number of website visits' => '',
          'Number of Makerble logins' => '0',
          'Source' => '',
          'Campaign code' => ''
      })
    end
  end
end
