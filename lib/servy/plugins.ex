defmodule Servy.Plugins do
  alias Servy.Conv

  @doc "rewrite 'AAA' to regular 'aaa'"
  def rewrite_path( %Conv{path: "/AAA"} = conv ) do
    %{ conv | path: "/aaa" }
  end

  @doc "Otherwise, just go pass it further in the chain"
  def rewrite_path( %Conv{} = conv ), do: conv

  @doc "Log shit"
  def log( %Conv{} = conv ) do
    IO.puts "\n*** This is conv: #{inspect conv}\n"
    conv
  end

  @doc "Track them 404 bitches"
  def track( %{status: 404, path: path} = conv ) do
    IO.puts "Nigga, things get outta hand: '#{path}' cannot be served'"
    conv
  end

  @doc "Dont do nuthin' when no 404, expcet for loggin'"
  def track( %Conv{} = conv ) do
    IO.puts "\n*** Final conv before formatting: #{inspect conv}\n"
    conv
  end
end
