defmodule P172Web.ErrorJSONTest do
  use P172Web.ConnCase, async: true

  test "renders 404" do
    assert P172Web.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert P172Web.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
