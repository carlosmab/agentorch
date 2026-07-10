defmodule Agentorch.Capability do
  @enforce_keys [:name]
  defstruct [
    :name,
    ttl: 60_000,
    max_retries: 3,
    visibility_timeout: 5_000,
    priority: 0,
    max_task_num: 20
  ]
end
