defmodule Scraper do
  @base_url "https://www.globalwhiskyauctions.com"

  def get_previous_auction_winners() do
    # winners = 
      # get_auctions_HTML()

      {_status, body} = build_single_list()

      lots = get_lot_number(body) 
              |> String.replace(~r/([A-Z])\w+/, "") 
              |> String.split(~r/:?\s/, trim: true)  

      titles = get_product_title(body)
      winning_bid = get_winning_bid(body)

      #  three different arrays
      
      for a <- lots, b <- titles, c <- winning_bid, do: {a,b,c}

            
      # Map.put(winner, :winning_lot, win_lot)
      
      


    # winners = 
    # get_auctions_HTML()
    #   |> Enum.map(fn {_, result} -> result.body end)
    #   |> Enum.map(fn body ->
    #       %{
    #         lot_number: get_lot_number(body),
    #         title: get_product_title(body),
    #         winning_bid: get_winning_bid(body)
    #       }
    #     end
    #     )
    # {:ok, winners }
  end


  def get_auctions_HTML() do
    get_previous_auction_urls()
    # |> build_urls()

    # |> Enum.map(fn url -> HTTPoison.get(url) end)
    |> Enum.map(fn {_, result} -> result.body end)
  end

  def build_single_list() do
    case HTTPoison.get("https://www.globalwhiskyauctions.com/thirty-first-auction-december-2019") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->

        {:ok, body}

        {:ok, %HTTPoison.Response{status_code: 404}} ->
          IO.puts "Not Found :("
        {:error, %HTTPoison.Error{reason: reason}} ->
          IO.inspect reason
    end 
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

  def get_lot_number(body) do
    body
      |> Floki.find("div.lot-watch")
      |> Floki.text()
  end

  def get_product_title(body) do
      body    
      |> Floki.find("div.productfieldhome")
      |> Floki.find("span.protitle")
      # {"span", [{"class", "protitle"}], ["Macallan Masters of Photography - Steven Klein El Celler de Can Roca - 70cl, 53.5%"]}

      |> Enum.map(fn({_, _, [whiskey]}) -> whiskey end)
  end

  def get_winning_bid(body) do
      body
      |> Floki.find("div.lotwin")
      |> Floki.find("span.uc-price")
      |> Enum.map(fn({_, _, [price]}) -> price end)
      # |> Floki.text()
  end



  def build_urls({_, urls}) do
    urls
    |> Enum.map(fn url -> @base_url <> "" <> url end)
  end



end
