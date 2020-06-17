defmodule Todo.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :todo,
  module: Todo.Guardian,
  error_handler: Todo.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
