Rails.application.config.after_initialize do
  # is the model you use as the admin(to authorization)
  RexyAdmin.auth_model = Admin
  # # use this if you want to use RexyAdmin's login feature
  RexyAdmin.use_rexy_admin_login = true
  RexyAdmin.login_field = :username
end
