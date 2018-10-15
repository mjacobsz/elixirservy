defmodule Servy.BearController do
  alias Servy.Conv
  alias Servy.Wildthings

  def index( %Conv{ method: "GET", path: "/bears" } = conv ) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(fn(b) -> b.type == "Grizzly" end)
      |> Enum.sort(fn(b1, b2) -> b1.name <= b2.name end)
      |> Enum.map(fn(b) -> "<li>#{b.name} - #{b.type}</li>" end)

    %{ conv | status: 200, resp_body: "<ul>#{items}</ul>" }
  end

  def show( %Conv{ method: "GET" } = conv, %{"id" => id} ) do
    %{ conv | status: 200, resp_body: "I found your fucking bear. Here it is: KjanseBEER nr#{id}. " }
  end

  def create( conv, %{ "name" => name, "type" => type } = params ) do
    IO.puts "Create a bear with #{name} and #{type}"
    %{ conv | status: 201, resp_body: "I created your fucking bear asshole" }
  end
end
