defmodule Auctions do
  def start(parsed, args, invalid) do
    if invalid != [] do
      show_help()
    else
      enter_select_auction_flow()
    end
  end

  def show_help() do
    IO.puts("""
        Usage: -[flags]

        Flags
        -u      Show previous URLs
        -a      Scrape last auction
    """)
  end

  def enter_select_auction_flow() do
    IO.puts("One moment while I fetch the list of previous auctions...")

    case Scraper.get_previous_auction_urls() do
      {:ok, urls} ->
        {:ok, auction_url} = ask_user_to_select_auction(urls)

      :error ->
        IO.puts("An unexpected error occured. Please try again...")
    end
  end

  @config_file "~/.auctions"
  @doc """
      Prompt the user to select an auction they want to view.
      The auctions's name/date combo will be saved to @config_file  for future lookups.
      This function can only ever return a {:ok, auction_url} tuple because an invalid
      selection will result in this funtion being recursively called.
  """
  def ask_user_to_select_auction(auctions) do
    IO.puts(auctions)
    #   auctions
    #   |> Enum.with_index(1)
    #   |> Enum.each(fn({location, index}) -> IO.puts " #{index} - #{location.name}" end)
    #   case IO.gets("Select a location number: ") |> Integer.parse() do
    #     :error ->
    #       IO.puts("Invalid selection. Try again.")
    #       ask_user_to_select_location(locations)
    #     {location_nb, _} ->
    #       case Enum.at(locations, location_nb - 1) do
    #         nil ->
    #           IO.puts("Invalid location number. Try again.")
    #           ask_user_to_select_location(locations)
    #         location ->
    #           IO.puts("You've selected the #{location.name} location.")
    #           File.write!(Path.expand(@config_file), to_string(:erlang.term_to_binary(location)))
    #           {:ok, location}
    #       end
    #   end
  end
end
