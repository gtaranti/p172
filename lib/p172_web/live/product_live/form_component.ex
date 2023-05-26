defmodule P172Web.ProductLive.FormComponent do
  use P172Web, :live_component

  alias P172.Products

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage product records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <P172Web.CoreComponents.input field={@form[:model]} type="text" label="Model" />
        <P172Web.CoreComponents.input field={@form[:price]} type="text" label="Price" />

        <div id="reviews">
          <.inputs_for :let={f_nested} field={@form[:reviews]}>
            <input type="hidden" name="product[reviews_order][]" />

            <div class="flex space-x-2">
              <input type="hidden" name="list[reviews_order][]" value={f_nested.index} />
              <P172Web.CoreComponents.input field={f_nested[:author]} type="text" label="Author" />
              <P172Web.CoreComponents.input field={f_nested[:stars]} type="text" label="Stars" />
            </div>
          </.inputs_for>
        </div>
        <label class="cursor-pointer">
          <input type="checkbox" name="product[reviews_order][]" class="" />
          <P172Web.CoreComponents.icon name="hero-plus-circle" /> add more
        </label>

        <:actions>
          <P172Web.CoreComponents.button phx-disable-with="Saving...">
            Save Product
          </P172Web.CoreComponents.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Products.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    product_params
    |> IO.inspect(label: "\nlib/p172_web/live/product_live/form_component.ex:#{__ENV__.line}")

    changeset =
      socket.assigns.product
      |> Products.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    case Products.update_product(socket.assigns.product, product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Products.create_product(product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
