defmodule Servy.Conv do
  defstruct headers: %{},
            method: "",
            params: %{},
            path: "",
            resp_body: "",
            status: nil

  def response_header(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
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
