defmodule JOSE.Mixfile do
  use Mix.Project

  def project do
    [app: :jose,
     version: "1.7.9",
     elixir: "~> 1.0",
     erlc_options: erlc_options,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     name: "JOSE",
     source_url: "https://github.com/potatosalad/erlang-jose",
     docs: fn ->
       {ref, 0} = System.cmd("git", ["rev-parse", "--verify", "--quiet", "HEAD"])
       [source_ref: ref, main: "JOSE", extras: ["README.md", "CHANGELOG.md",
        "examples/KEY-GENERATION.md", "ALGORITHMS.md"]]
     end,
     description: description,
     package: package]
  end

  def application do
    [mod: {:jose_app, []},
     applications: [:crypto, :asn1, :public_key, :base64url]]
  end

  defp deps do
    [{:base64url, "~> 0.0.1"},
     {:cutkey, github: "potatosalad/cutkey", only: [:dev, :test]},
     {:jsone, "~> 1.2", only: [:dev, :test]},
     {:jsx, "~> 2.8", only: [:dev, :test]},
     # {:keccakf1600, "~> 2.0.0", only: [:dev, :test]},
     {:libdecaf, "~> 0.0.3", only: [:dev, :test]},
     # {:libsodium, "~> 0.0.3", only: [:dev, :test]},
     {:poison, "~> 2.2", only: [:dev, :test]},
     {:ex_doc, "~> 0.12", only: :docs},
     {:earmark, "~> 0.2", only: :docs}]
  end

  defp description do
    "JSON Object Signing and Encryption (JOSE) for Erlang and Elixir."
  end

  def erlc_options do
    extra_options = try do
      case :erlang.list_to_integer(:erlang.system_info(:otp_release)) do
        v when v >= 18 ->
          [{:d, :optional_callbacks}]
        _ ->
          []
      end
    catch
      _ ->
        []
    end
    [:debug_info | (if Mix.env == :prod, do: [], else: [:warnings_as_errors]) ++ extra_options]
  end

  defp package do
    [maintainers: ["Andrew Bennett"],
     files: [
       "CHANGELOG*",
       "include",
       "lib",
       "LICENSE*",
       "priv",
       "mix.exs",
       "README*",
       "rebar.config",
       "src"
     ],
     licenses: ["Mozilla Public License Version 2.0"],
     links: %{"Github" => "https://github.com/potatosalad/erlang-jose",
              "Docs" => "https://hexdocs.pm/jose"}]
  end
end
