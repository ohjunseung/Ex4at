defmodule Chat do
  defmodule Message do
    @type t :: %__MODULE__{from: String.t(), message: String.t()}
    defstruct [:from, :message]
  end

  defmodule User do
    @type t :: %__MODULE__{addr: String.t(), pid: pid()}
    defstruct [:addr, :pid]
  end
end
