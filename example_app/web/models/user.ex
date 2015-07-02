defmodule ExampleApp.Models.User do
  use Ecto.Model
  schema "users" do
    field :email, :string
    field :hash, :string
    field :recovery_hash, :string
    timestamps
  end

end
