unless Rails.env.production?
  GoCardless.environment = :sandbox
end
