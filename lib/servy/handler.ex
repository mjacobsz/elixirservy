defmodule Servy.Handler do
  @moduledoc """
  Hey you the rocksteady crew
  """
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser,  only: [parse: 1]

  @pages_path Path.expand("../../pages", __DIR__)

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def route(%{ method: "GET", path: "/aaa" } = conv), do: %{ conv | status: 200, resp_body: "Crap van AAAaars" }

  def route(%{ method: "GET", path: "/bbb" } = conv), do: %{ conv | status: 200, resp_body: "Crap van BBB" }

  def route(%{ method: "GET", path: "/bbb/" <> id } = conv), do: %{ conv | status: 200, resp_body: "I found your fucking bear. Here it is: KjanseBEER nr#{id}.  " }

  def route(%{ method: "GET", path: "/about" } = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> handle_read(conv)
  end

  def route(%{ path: path } = conv), do: %{ conv | status: 404, resp_body: "There's no '#{path}' here, mofo" }

  def handle_read({ :ok, contents }, conv) do
    %{ conv | status: 200, resp_body: contents }
  end

  def handle_read({ :error, :enoent }, conv) do
    %{ conv | status: 404, resp_body: "File not found niggaboi" }
  end

  def handle_read({ :error, reason }, conv) do
    %{ conv | status: 500, resp_body: "Something went completely wrong. Wanna know why? Here: #{reason}" }
  end

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
