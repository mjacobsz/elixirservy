defmodule Servy.Plugins do
  def rewrite_path(%{path: "/AAA"} = conv) do
    %{ conv | path: "/aaa" }
  end

  def rewrite_path(conv), do: conv

  @doc "Log shit"
  def log(conv), do: IO.inspect conv

  def track(%{status: 404, path: path} = conv) do
    IO.puts "Nigga, things get outta hand: '#{path}' cannot be served'"
    conv
  end

  def track(conv), do: conv
end
