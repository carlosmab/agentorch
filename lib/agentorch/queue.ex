defmodule Agentorch.Queue do
  use GenServer
  alias Agentorch.Task

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    config = Keyword.fetch!(opts, :config)
    {:ok, %{tasks: %{}, config: config}}
  end

  def push(capability, payload) do
    GenServer.call(__MODULE__, {:push, capability, payload})
  end

  @impl true
  def handle_call({:push, _capability, _payload}, _from, state) when map_size(state.tasks) >= state.config.max_queue_depth do
    {:replay, {:error, :queue_full}, state}
  end

  @impl true
  def handle_call({:push, capability, payload}, _from, state) do
    cap_config = Map.get(state.config.capabilities, capability)
    cap_task_count = count_tasks_per_capability(state.tasks, capability)

    cond do
      is_nil (cap_config) ->
        {:reply, {:error, :unknown_capability}, state}

      cap_task_count >= cap_config.max_task_num ->
        {:reply, {:error, :capability_full}, state}

      true ->
        id = UUID.uuid4()
        task = %Task{
          id: id,
          capability: capability,
          payload: payload,
          inserted_at: DateTime.utc_now()
        }

        new_tasks = Map.put(state.tasks, id, task)
        new_state = %{state | tasks: new_tasks}
        {:reply, {:ok, id}, new_state}

    end
  end

  defp count_tasks_per_capability(tasks, capability) do
    tasks
    |> Map.values()
    |> Enum.count(fn task -> task.capability == capability and task.status != :done end)
  end

end
