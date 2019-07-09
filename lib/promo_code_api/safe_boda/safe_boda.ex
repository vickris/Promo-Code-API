defmodule PromoCodeApi.SafeBoda do
  @moduledoc """
  The SafeBoda context.
  """

  import Ecto.Query, warn: false
  alias PromoCodeApi.Repo

  alias PromoCodeApi.SafeBoda.Location

  @doc """
  Returns the list of locations.

  ## Examples

      iex> list_locations()
      [%Location{}, ...]

  """
  def list_locations do
    Repo.all(Location)
  end

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!(123)
      %Location{}

      iex> get_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location!(id), do: Repo.get!(Location, id)

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Location.

  ## Examples

      iex> delete_location(location)
      {:ok, %Location{}}

      iex> delete_location(location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location changes.

  ## Examples

      iex> change_location(location)
      %Ecto.Changeset{source: %Location{}}

  """
  def change_location(%Location{} = location) do
    Location.changeset(location, %{})
  end

  alias PromoCodeApi.SafeBoda.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  alias PromoCodeApi.SafeBoda.Promo

  @doc """
  Returns the list of promos.

  ## Examples

      iex> list_promos()
      [%Promo{}, ...]

  """
  def list_promos do
    Repo.all(Promo)
  end

  @doc """
  Returns the list of active promos.

  ## Examples

      iex> list_active_promos()
      [%Promo{}, ...]

  """
  def list_active_promos do
    Repo.all(from p in Promo, where: p.is_deactivated == false and p.is_expired == false);
  end

  @doc """
  Gets a single promo.

  Raises `Ecto.NoResultsError` if the Promo does not exist.

  ## Examples

      iex> get_promo!(123)
      %Promo{}

      iex> get_promo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_promo!(id), do: Repo.get!(Promo, id)

  @doc """
  Creates a promo.

  ## Examples

      iex> create_promo(%{field: value})
      {:ok, %Promo{}}

      iex> create_promo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_promo(attrs \\ %{}) do
    %Promo{}
    |> Promo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a promo.

  ## Examples

      iex> update_promo(promo, %{field: new_value})
      {:ok, %Promo{}}

      iex> update_promo(promo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_promo(%Promo{} = promo, attrs) do
    promo
    |> Promo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Promo.

  ## Examples

      iex> delete_promo(promo)
      {:ok, %Promo{}}

      iex> delete_promo(promo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_promo(%Promo{} = promo) do
    Repo.delete(promo)
  end

  @doc """
  Deactivates a Promo.

  ## Examples

      iex> deactivate_promo(promo)
      {:ok, %Promo{}}

      iex> deactivate_promo(promo)
      {:error, %Ecto.Changeset{}}

  """
  def deactivate_promo(%Promo{} = promo, attrs) do
    promo
    |> Promo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking promo changes.

  ## Examples

      iex> change_promo(promo)
      %Ecto.Changeset{source: %Promo{}}

  """
  def change_promo(%Promo{} = promo) do
    Promo.changeset(promo, %{})
  end
end
