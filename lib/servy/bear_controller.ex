defmodule Servy.BearController do
  alias Servy.Conv
  alias Servy.Bear
  alias Servy.Wildthings

  @templates_path Path.expand("../../templates", __DIR__)

  defp render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{ conv | status: 200, resp_body: content }
  end

  def index( %Conv{ method: "GET", path: "/bears" } = conv ) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    render(conv, "index.eex", bears: bears)
  end

  def show( %Conv{ method: "GET" } = conv, %{"id" => id} ) do
    bear = Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
  end

  def create( conv, %{ "name" => name, "type" => type }) do
    IO.puts "Create a bear with #{name} and #{type}"
    %{ conv | status: 201, resp_body: "I created your fucking bear asshole" }
  end
end
