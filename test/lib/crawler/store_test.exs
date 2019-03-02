defmodule Crawler.StoreTest do
  use Crawler.TestCase, async: true

  alias Crawler.Store

  setup do
    Store.init
    :ok
  end

  test "save_body set to true writes the body to the store" do
    Store.add("foo")
    Store.add_page_data("foo", "bar", %{save_body: true})
    page = Store.find("foo")
    assert page.body == "bar"
  end

  test "save_body false to false does not write the body to the store" do
    Store.add("foo")
    Store.add_page_data("foo", "bar", %{save_body: false})
    page = Store.find("foo")
    assert page.body == nil
  end

end
