SimpleRoles.configure do
  valid_roles :admin, :moderator, :janitor
  strategy :one
end