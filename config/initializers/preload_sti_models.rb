# add config/initializers/preload_sti_models.rb:
#
if Rails.env.development?
  %w[aws rackspace].each do |c|
    require_dependency File.join("app","models/cloud_providers","#{c}.rb")
  end
end