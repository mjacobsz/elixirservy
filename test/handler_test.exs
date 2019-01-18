defmodule HandlerTest do
  use ExUnit.Case
  doctest Servy.Parser

  import Servy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildlife HTTP/1.1
    Host: example.com
    User-agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 45

    Crap van AAAaars, so that means wildlife crap
    """
  end

  test "GET /this-should-throw-a-404" do
    request = """
    GET /thisshouldthrowa404 HTTP/1.1
    Host: example.com
    User-agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    assert response == """
    HTTP/1.1 404 Not found
    Content-Type: text/html
    Content-Length: 44

    There's no '/thisshouldthrowa404' here, mofo
    """
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1
    Host: example.com
    User-agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 263

    <h1>All the bears</h1>

    <ul>

      <li>Brutus - Grizzly

      <li>Iceman - Polar

      <li>Kenai - Grizzly

      <li>Paddington - Brown

      <li>Roscoe - Panda

      <li>Rosie - Black

      <li>Scarface - Grizzly

      <li>Smokey - Black

      <li>Snow - Polar

      <li>Teddy - Brown

    </ul>

    """
  end

  test "GET /bears/7" do
    request = """
    GET /bears/7 HTTP/1.1
    Host: example.com
    User-agent: ExampleBrowser/1.0
    Accept: */*

    """
    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 72

    <h1>Show bear</h1>
    <p>
    Is Rosie hibernating? <strong>true</strong>
    </p>

    """
  end

  test "" do
    request = """
    POST /bears HTTP/1.1
    Host: example.com
    User-agent: ExampleBrowser/1.0
    Accept: */*
    Content-Type: application/x-www-form-urlencoded
    Content-Length: 21

    name=Bar&type=cat
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created
    Content-Type: text/html
    Content-Length: 35

    I created your fucking bear asshole
    """
  end
end
