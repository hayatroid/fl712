defmodule Fl712 do
  @moduledoc false

  use WebSockex
  require Logger

  @ws_url "wss://q.trap.jp/api/v3/bots/ws"
  @http_url "https://q.trap.jp/api/v3"

  def start_link(token) do
    state = %{token: token}
    extra_headers = [{"Authorization", "Bearer #{token}"}]
    WebSockex.start_link(@ws_url, __MODULE__, state, extra_headers: extra_headers)
  end

  def handle_frame({:text, event_json}, state) do
    case Jason.decode(event_json) do
      {:ok, event} ->
        handle_event(event, state)

      {:error, reason} ->
        Logger.error("JSON のデコードに失敗して 🙀: #{inspect(reason)}")
    end

    {:ok, state}
  end

  def handle_frame(_frame, state), do: {:ok, state}

  defp handle_event(
         %{
           "type" => "DIRECT_MESSAGE_CREATED",
           "body" => body
         },
         state
       ) do
    handle_direct_message(body, state)
  end

  defp handle_event(_event, _state), do: :ok

  defp handle_direct_message(
         %{
           "message" => %{
             "channelId" => channel_id,
             "text" => text,
             "user" => %{"bot" => false}
           }
         },
         state
       ) do
    reply(channel_id, reply_for(text), state.token)
  end

  defp handle_direct_message(_body, _state), do: :ok

  defp reply_for("そして、栄えあるワーストランキング第一位は、"), do: "大納言あずき"
  defp reply_for(_text), do: "チョコミント"

  defp reply(channel_id, content, token) do
    url = "#{@http_url}/channels/#{channel_id}/messages"
    headers = [Authorization: "Bearer #{token}"]
    json = %{content: content}

    case Req.post(url, json: json, headers: headers) do
      {:ok, _response} -> :ok
      {:error, reason} -> Logger.error("メッセージの送信に失敗して 🙀: #{inspect(reason)}")
    end
  end
end
