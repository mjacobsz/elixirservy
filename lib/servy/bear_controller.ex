defmodule Servy.BearController do
  alias Servy.Conv
  alias Servy.Bear
  alias Servy.Wildthings

  def index( %Conv{ method: "GET", path: "/bears" } = conv ) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Enum.map(&Bear.as_html_list_item/1)

    %{ conv | status: 200, resp_body: "<ul>#{items}</ul>" }
  end

  def show( %Conv{ method: "GET" } = conv, %{"id" => id} ) do
    bear = Wildthings.get_bear(id)
    %{ conv | status: 200, resp_body: "<h1>Here's your bear, sir: #{id}. #{bear.name} </h1>" }
  end

  def create( conv, %{ "name" => name, "type" => type } = params ) do
    IO.puts "Create a bear with #{name} and #{type}"
    %{ conv | status: 201, resp_body: "I created your fucking bear asshole" }
  end
end
