defmodule Demo.WebSocketHandler do
  @behaviour :cowboy_websocket
  @topic "mytopic"

  def init(req, opts), do: {:cowboy_websocket, req, opts}

  def terminate(_reason, _req, _opts) do
    Phoenix.PubSub.unsubscribe(:chat_pubsub, @topic)
    :ok
  end

  def websocket_init(opts) do
    Phoenix.PubSub.subscribe(:chat_pubsub, @topic)
    {:ok ,opts}
  end

  def websocket_handle({:text, content}, opts) do
    Phoenix.PubSub.broadcast(:chat_pubsub, @topic, {:text, content})
    {:ok, opts}
  end
  def websocket_handle(_frame, opts), do: {:ok, opts}

  def websocket_info({:text, content}, opts), do: {:reply, {:text, content}, opts}
  def websocket_info(info, opts), do: {:ok, opts}
end
