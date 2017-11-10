defmodule Servy.Handler do
  def handle(request) do
    request
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

  def route(%{ method: "GET", path: "/aaa" } = conv), do: %{ conv | status: 200, resp_body: "Crap van AAA" }

  def route(%{ method: "GET", path: "/bbb" } = conv), do: %{ conv | status: 200, resp_body: "Crap van BBB" }

  def route(%{ method: "GET", path: "/bbb/" <> id } = conv), do: %{ conv | status: 200, resp_body: "I found your fucking bear. Here it is: KjanseBEER nr#{id}.  " }

  def route(%{ path: path } = conv), do: %{ conv | status: 404, resp_body: "There's no '#{path}' here, mofo" }

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
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

request = """
GET /aaa HTTP/1.1
Host: example.com
User-agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)
