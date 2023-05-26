defmodule P172Web.TestLive do
  use P172Web, :live_view

  defmodule Person do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field(:name, :string)

      embeds_many :cities, City, on_replace: :delete do
        field(:name, :string)
        field(:rating, :integer)
      end
    end

    def changeset(form, params) do
      form
      |> cast(params, [:name])
      |> validate_required([:name])
      |> cast_embed(:cities,
        with: &city_changeset/2,
        sort_param: :cities_order,
        drop_param: :cities_delete
      )
    end

    def city_changeset(city, params) do
      city
      |> cast(params, [:name])
      |> validate_required([:name])
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <div>
        <h1>Test Live</h1>

        <P172Web.CoreComponents.simple_form
          for={@form}
          id="main-form"
          phx-change="validate"
          phx-submit="submit"
        >
          <.field type="text" field={@form[:name]} />
          <div id="main" class="space-y-2">
            <.inputs_for :let={f_nested} field={@form[:cities]}>
              <div class="flex space-x-2">
                <input type="hidden" name="person[cities_order][]" value={f_nested.index} />
                <.field type="text" field={f_nested[:name]} />
                <div>
                  <.form_field
                    type="radio_group"
                    options={[{"1", "1"}, {"2", "2"}, {"3", "3"}, {"4", "4"}, {"5", "5"}]}
                    form={f_nested}
                    field={:rating}
                    layout={:row}
                  label="Rating with form_field"
                  />
                </div>
                <.field
                  type="radio-group"
                  options={[{"1", "1"}, {"2", "2"}, {"3", "3"}, {"4", "4"}, {"5", "5"}]}
                  field={f_nested[:rating]}
                  group_layout="row"
                  label="Rating with field"
                />
                <label class="cursor-pointer">
                  <input
                    type="checkbox"
                    id={"delete-btn-#{f_nested.id}"}
                    class="hidden pt-4"
                    name="person[cities_delete][]"
                    value={f_nested.index}
                  />
                  <P172Web.CoreComponents.icon name="hero-x-mark" />
                </label>
              </div>
            </.inputs_for>
          </div>
          <label class="cursor-pointer">
            <input
              type="checkbox"
              id={"add-btn-#{Phoenix.HTML.Form.inputs_for(@form, :cities) |> length()}"}
              class="hidden"
              name="person[cities_order][]"
            />
            <P172Web.CoreComponents.icon name="hero-plus-circle" /> add more
          </label>
        </P172Web.CoreComponents.simple_form>
      </div>
    </.container>
    """
  end

  @impl true
  def mount(
        _params,
        _session,
        socket
      ) do
    base = %Person{
      id: "4e4d0944-60b3-4a09-a075-008a94ce9b9e",
      name: "Somebody",
      cities: [
        %Person.City{
          id: "26d59961-3b19-4602-b40c-77a0703cedb5",
          name: "Berlin",
          rating: 3
        },
        %Person.City{
          id: "330a8f72-3fb1-4352-acf2-d871803cd152",
          name: "Singapour",
          rating: 4
        }
      ]
    }

    changeset = Person.changeset(base, %{})

    {:ok, assign(socket, form: to_form(changeset))}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"person" => person} = _params, socket) do
    form =
      %Person{}
      |> Person.changeset(person)
      |> Map.put(:action, :insert)
      |> to_form()

    {:noreply, socket |> assign(form: form)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    {:noreply, socket}
  end
end
