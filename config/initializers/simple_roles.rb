SimpleRoles.configure do
  valid_roles :operator, :administrator, :moderator, :janitor
  strategy :one
end