defmodule Agentorch.Config do
  @enforce_keys [:capabilities]
  defstruct [
    :capabilities,
    max_queue_depth: 100
  ]

  def normalize_capabilities(%__MODULE__{capabilities: capabilities} = config) when is_list(capabilities) do
    capabilities_map =
      capabilities
      |> Enum.map(fn cap -> {cap.name, cap} end)
      |> Map.new()

    %{config | capabilities: capabilities_map}
  end

  def normalize_capabilites(%__MODULE__{} = config), do: config

end
