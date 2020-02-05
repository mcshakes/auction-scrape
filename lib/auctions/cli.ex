defmodule Auctions.CLI do
  def main(argv) do
    argv
    |> parse_args()
  end

  def parse_args(argv) do
    # args =
    #   OptionParser.parse(
    #     argv,
    #     strict: [help: :boolean, urls: :boolean],
    #     alias: [h: :help]
    #   )

    args =
      OptionParser.parse(
        argv,
        strict: [help: :boolean, urls: :boolean],
        alias: [h: :help]
      )

    case argv do
      {[help: true], _, _} ->
        :help

      {[], [], [{"-h", nil}]} ->
        :help
    end

    # IO.puts({parsed, args, invalid})
    # Auctions.start(parsed, argv, invalid)
  end

  def process(:help) do
    Auctions.show_help()
  end
end
