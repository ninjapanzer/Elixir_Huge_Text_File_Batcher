defmodule PhoneReader.Mixfile do
  use Mix.Project

  def project do
    [app: :phone_reader,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  defp deps do
    [{:postgrex, ">= 0.0.0"},
     {:ecto, "~> 2.0.0-beta"}]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      mod: {PhoneReader.App, []},
      applications: [:logger, :postgrex, :ecto]
    ]
  end
end
