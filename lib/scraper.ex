defmodule Scraper do
  @base_url "https://www.globalwhiskyauctions.com"


  def get_auctions_HTML() do
    get_previous_auction_urls()
    |> build_urls()
    |> Enum.map(fn url -> HTTPoison.get(url) end)
  end

  def get_previous_auction_urls() do
    case HTTPoison.get("https://www.globalwhiskyauctions.com/previous-auctions") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        urls =
          body
          |> Floki.find("section#block-views-previous-auctions-block")
          |> Floki.find("a") 
          |> Floki.attribute("href")

        {:ok, urls}

        {:ok, %HTTPoison.Response{status_code: 404}} ->
          IO.puts "Not Found :("
        {:error, %HTTPoison.Error{reason: reason}} ->
          IO.inspect reason
    end        
  end

  def build_urls({_, urls}) do
    urls
    |> Enum.map(fn url -> @base_url <> "" <> url end)
  end



end
