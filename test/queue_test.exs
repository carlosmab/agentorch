defmodule Agentorch.QueueTest do
  use ExUnit.Case

  alias Agentorch.{Queue, Config, Capability}

  setup do
    config = %Config{capabilities: %{email: %Capability{name: :email}}}
    {:ok, pid} = Queue.start_link(config: config)
    %{queue: pid}
  end

  test "push succeds for a registered capability" do
    assert {:ok, _id} = Queue.push(:email, %{to: "x@email.com"})
  end

  test "push fails for an unregistered capability" do
    assert {:error, :unknown_capability} = Queue.push(:sms, %{})
  end

  test "normalize_capabilities converts a list to a map keyed by name" do
    config = %Config{capabilities: [%Capability{name: :email}]}
    normalized = Config.normalize_capabilities(config)
    assert normalized.capabilities == %{email: %Capability{name: :email}}
  end

end
