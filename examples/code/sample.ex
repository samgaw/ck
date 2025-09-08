defmodule AdvancedElixirExample do
  @moduledoc """
  Comprehensive example showcasing advanced Elixir syntax features
  that are now supported by the enhanced semantic chunking.
  """

  # Type specifications and documentation
  @type user_state :: :active | :inactive | :pending
  @type user_data :: %{name: String.t(), email: String.t(), state: user_state()}
  @opaque internal_id :: {atom(), integer()}

  # Struct definition
  defstruct [:id, :name, :email, :state, :metadata]

  @doc """
  Creates a new user with the given parameters.
  Demonstrates comprehensive pattern matching and control flow.
  """
  @spec create_user(String.t(), String.t()) :: {:ok, t()} | {:error, atom()}
  def create_user(name, email) when is_binary(name) and is_binary(email) do
    case validate_email(email) do
      {:ok, normalized_email} ->
        with {:ok, id} <- generate_id(),
             {:ok, state} <- determine_initial_state(name),
             user = %__MODULE__{
               id: id,
               name: String.trim(name),
               email: normalized_email,
               state: state,
               metadata: %{}
             } do
          {:ok, user}
        else
          {:error, reason} -> {:error, reason}
        end
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Processes a list of users with various control flow constructs.
  """
  @spec process_users([t()]) :: [t()]
  def process_users(users) do
    for user <- users do
      if user.state == :pending do
        try do
          updated_user = update_user_state(user, :active)
          
          case validate_user(updated_user) do
            {:ok, valid_user} -> valid_user
            {:error, _reason} -> %{user | state: :inactive}
          end
        rescue
          error -> 
            IO.warn("Error processing user #{user.id}: #{inspect(error)}")
            user
        catch
          :exit, reason ->
            IO.warn("Exit during processing: #{inspect(reason)}")
            user
        after
          log_processing_complete(user.id)
        end
      else
        user
      end
    end
  end

  # Callback definitions for behaviour
  @callback handle_user_event(t(), term()) :: {:ok, t()} | {:error, term()}
  @macrocallback create_handler(atom()) :: Macro.t()

  # Macro definition with quote/unquote
  defmacro def_user_handler(name, body) do
    quote do
      def unquote(:"handle_#{name}")(%__MODULE__{} = user, event) do
        unquote(body)
        |> case do
          {:ok, result} -> {:ok, %{user | metadata: Map.put(user.metadata, unquote(name), result)}}
          error -> error
        end
      end
    end
  end

  # Using the macro
  def_user_handler :email_changed, do: validate_email(event[:new_email])
  def_user_handler :state_transition, do: {:ok, event[:new_state]}

  @doc """
  String processing with sigils and interpolation
  """
  def process_text_data(input) do
    # Regular expressions
    email_regex = ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
    
    # Word lists
    stop_words = ~w[the and or but in on at to for of with by]
    
    # String sigils with interpolation
    template = ~s"""
    User Processing Report
    ======================
    Input: #{input}
    Timestamp: #{DateTime.utc_now()}
    Status: Processing complete
    """
    
    # Character lists for legacy systems
    legacy_format = ~c'USER_DATA_PROCESSED'
    
    {email_regex, stop_words, template, legacy_format}
  end

  # Private helper functions
  defp validate_email(email) do
    email_regex = ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
    if Regex.match?(email_regex, email) do
      {:ok, String.downcase(email)}
    else
      {:error, :invalid_email}
    end
  end

  defp generate_id do
    {:ok, {:user, System.unique_integer()}}
  end

  defp determine_initial_state(name) do
    case String.length(String.trim(name)) do
      length when length > 0 -> {:ok, :pending}
      _ -> {:error, :invalid_name}
    end
  end

  defp update_user_state(%__MODULE__{} = user, new_state) do
    %{user | state: new_state}
  end

  defp validate_user(%__MODULE__{} = user) do
    {:ok, user}
  end

  defp log_processing_complete(id) do
    IO.puts("Processing complete for user: #{inspect(id)}")
  end
end

# Protocol definition
defprotocol UserSerializer do
  @doc "Serializes user data to various formats"
  def serialize(user, format)
end

# Protocol implementation
defimpl UserSerializer, for: AdvancedElixirExample do
  def serialize(user, :json) do
    Jason.encode(user)
  end
  
  def serialize(user, :string) do
    "User(#{user.name}, #{user.email}, #{user.state})"
  end
end

# Behaviour definition and implementation
@behaviour AdvancedElixirExample
defmodule UserEventHandler do
  def handle_user_event(user, event) do
    {:ok, user}
  end
end