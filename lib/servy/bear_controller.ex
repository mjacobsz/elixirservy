defmodule Servy.BearController do
  alias Servy.Conv

  def route( %Conv{ method: "GET", path: "/bears" } = conv ), do: %{ conv | status: 200, resp_body: "Crap van BBB" }

  def route( %Conv{ method: "GET", params: params } = conv ), do: %{ conv | status: 200, resp_body: "I found your fucking bear. Here it is: KjanseBEER nr#{params.id}.  " }

  def create( conv, %{ "name" => name, "type" => type } = params ) do
    IO.puts "Create a bear with #{name} and #{type}"
    %{ conv | status: 201, resp_body: "I created your fucking bear asshole" }
  end
end
