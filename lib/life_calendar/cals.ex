defmodule LifeCalendar.Cals do
  @moduledoc """
  The Cals context.
  """

  import Ecto.Query, warn: false
  alias LifeCalendar.Repo

  alias LifeCalendar.Cals.Cal

  @doc """
  Returns the list of cals.

  ## Examples

      iex> list_cals()
      [%Cal{}, ...]

  """
  def list_cals do
    Repo.all(Cal)
  end

  @doc """
  Gets a single cal.

  Raises `Ecto.NoResultsError` if the Cal does not exist.

  ## Examples

      iex> get_cal!(123)
      %Cal{}

      iex> get_cal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cal!(id), do: Repo.get!(Cal, id)

  @doc """
  Creates a cal.

  ## Examples

      iex> create_cal(%{field: value})
      {:ok, %Cal{}}

      iex> create_cal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cal(attrs \\ %{}) do
    %Cal{}
    |> Cal.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cal.

  ## Examples

      iex> update_cal(cal, %{field: new_value})
      {:ok, %Cal{}}

      iex> update_cal(cal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cal(%Cal{} = cal, attrs) do
    cal
    |> Cal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cal.

  ## Examples

      iex> delete_cal(cal)
      {:ok, %Cal{}}

      iex> delete_cal(cal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cal(%Cal{} = cal) do
    Repo.delete(cal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cal changes.

  ## Examples

      iex> change_cal(cal)
      %Ecto.Changeset{data: %Cal{}}

  """
  def change_cal(%Cal{} = cal, attrs \\ %{}) do
    Cal.changeset(cal, attrs)
  end
end
