defmodule Agentorch.Task do
  @enforce_keys [:id, :capability, :payload, :inserted_at]
  defstruct [
    :id,
    :capability,
    :payload,
    :inserted_at,
    status: :waiting,
    retry_count: 0,
    claimed_at: nil,
    priority: 0,
    is_urgent: false
  ]
end
