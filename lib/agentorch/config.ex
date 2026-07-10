defmodule Agentorch.Config do
  @enforce_keys [:capabilities]
  defstruct [
    :capabilities,
    max_queue_depth: 100
  ]

end
