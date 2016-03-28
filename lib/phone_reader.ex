defmodule PhoneReader.App do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    tree = [supervisor(PhoneReader.Repo, [])]
    opts = [name: PhoneReader.Sup, strategy: :one_for_one]
    Supervisor.start_link(tree, opts)
  end
end

defmodule PhoneReader.Repo do
  use Ecto.Repo,
    otp_app: :phone_reader
end

defmodule PhoneNumber do
  use Ecto.Schema

  schema "numbers" do
    field :area_code
    field :prefix
    field :suffix
    field :current, :boolean
    timestamps
  end
end

defmodule PhoneReader do
  import Ecto.DateTime

  def extract do
    File.stream!("../../donotcall-api/2016-1-5_PA_47F351F4-8033-44DA-89FC-361D73FA7264.txt") |> Stream.chunk(1000) |> Stream.with_index |> Enum.each(fn chunk ->
      {numbers, index} = chunk
      spawn fn ->
        IO.puts index
        PhoneReader.Repo.insert_all(PhoneNumber, Enum.map(numbers, fn number ->
          [area|rest] = String.split(number, ",")
          prefix = String.slice(List.last(rest), 0..3)
          suffix = String.slice(List.last(rest), -4..-1)
          %{
            area_code: area,
            prefix: prefix,
            suffix: suffix,
            current: true,
            inserted_at: Ecto.DateTime.utc,
            updated_at: Ecto.DateTime.utc
          }
        end))
      end
    end)
  end
end
