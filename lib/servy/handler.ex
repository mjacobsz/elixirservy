defmodule Servy.Handler do

  def handle, do: handle("/aaa")

  def handle(path) do
    request(path)
    |> parse
    |> log
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method, path: path, status: nil, resp_body: "" }
  end

  def log(conv), do: IO.inspect conv

  def route(conv), do: route(conv, conv.method, conv.path)

  def route(conv, "GET", "/aaa"), do: %{ conv | status: 200, resp_body: "Crap van AAA" }

  def route(conv, "GET", "/bbb"), do: %{ conv | status: 200, resp_body: "Crap van BBB" }

  def route(conv, "GET", "/bbb/" <> i), do: %{ conv | status: 200, resp_body: "Individuele BBB, nummertje #{i}" }

  def route(conv, _method, path), do: %{ conv | status: 404, resp_body: "There's no '#{path}' here, mofo" }

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  def request(path \\ "/aaa", method \\ "GET") do
    """
    #{method} #{path} HTTP/1.1
    Host: example.com
    User-agent: ExampleBrowser/1.0
    Accept: */*

    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      403 => "Forbidden",
      404 => "Not found",
      500 => "Internal server error"
    }[code]
  end

end
