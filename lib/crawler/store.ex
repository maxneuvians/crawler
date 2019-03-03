defmodule Crawler.Store do
  @moduledoc """
  An internal data store for information related to each crawl.
  """

  alias __MODULE__.DB

  defmodule Page do
    @moduledoc """
    An internal struct for keeping the url and content of a crawled page.
    """

    defstruct [:url, :body, :opts, :processed]
  end

  @doc """
  Initialises a new `Registry` named `Crawler.Store.DB`.
  """
  def init do
    :ets.new(DB, [:set, :public, :named_table])
  end

  def list do
    :ets.tab2list(DB)
  end

  @doc """
  Finds a stored URL and returns its page data.
  """
  def find(url) do
    case :ets.lookup(DB, url) do
      [{_, page}] -> page
      _           -> nil
    end
  end

  @doc """
  Finds a stored URL and returns its page data only if it's processed.
  """
  def find_processed(url) do
    case find(url) do
      %{processed: true} = page -> page
      _ -> nil
    end 
  end

  @doc """
  Adds a URL to the registry.
  """
  def add(url) do
    :ets.insert(DB, {url, %Page{url: url}})
    {:ok, true}
  end

  @doc """
  Adds the page data for a URL to the registry. Only saves the body if the
  save_body option is set to true.
  """
  def add_page_data(url, _body, %{save_body: false} = opts) do
    page = find(url)
    :ets.insert(DB, {url, %{page | opts: opts}})
    {:ok, true}
  end
  def add_page_data(url, body, opts) do
    page = find(url)
    :ets.insert(DB, {url, %{page | body: body, opts: opts}})
    {:ok, true}
  end

  @doc """
  Marks a URL as processed in the registry.
  """
  def processed(url) do
    page = find(url)
    :ets.insert(DB, {url, %{page | processed: true}})
    {:ok, true}
  end
end
