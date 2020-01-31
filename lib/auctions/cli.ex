defmodule Auctions.CLI do
    def main(argv) do
        argv
        |> parse_args()
        |> process()
    end

    def parse_args(argv) do
        args = OptionParser.parse(
            argv,
            strict: [help: :boolean, winners: :boolean],
            alias: [h: :help]
        )

        case args do
            {[help: true], _, _} ->
                :help

            {[], [], [{"-h", nil}]} ->
                :help

            {[winners: true], _, _} ->
                :list_previous_auctions

            {[], [], []} ->
                :list

            _ -> 
                :invalid_arg
        end
    end

    def process(:help) do
        IO.puts """
            auctions --urls  # Select from a bunch of previous auction URLS
        """
        System.halt(0)
    end

    def process(:list_previous_auctions) do
        Auctions.enter_select_auction_flow()
    end

    # def process(:list_soups) do
    #     Soup.fetch_soup_list()
    # end

    def process(:invalid_arg) do
        IO.puts "Invalid argument(s) passed. See usage below:"
        process(:help)
    end
end