defmodule Excards do
	use Application

	# See http://elixir-lang.org/docs/stable/elixir/Application.html
	# for more information on OTP Applications
	def start(_type, _args) do
		import Supervisor.Spec, warn: false

		children = [
		# Define workers and child supervisors to be supervised
		# worker(Excards.Worker, [arg1, arg2, arg3]),
		]

		# See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
		# for other strategies and supported options
		opts = [strategy: :one_for_one, name: Excards.Supervisor]
		Supervisor.start_link(children, opts)
	end

	###############
	### commons ###
	###############

	@type suit :: :Hearts | :Spades | :Diamonds | :Clubs | nil
	@suits [:Hearts, :Spades, :Diamonds, :Clubs]
	@spec suits :: [Excards.suit]
	def suits, do: @suits

	@type value :: :V2 | :V3 | :V4 | :V5 | :V6 | :V7 | :V8 | :V9 | :V10 | :Jack | :Queen | :King | :Ace | :JokerRed | :JokerBlack
	@values [:V2, :V3, :V4, :V5, :V6, :V7, :V8, :V9, :V10, :Jack, :Queen, :King, :Ace, :JokerRed, :JokerBlack]
	@values_map %{
		24 => Enum.filter(@values, &(not(&1 in [:JokerRed, :JokerBlack, :V2, :V3, :V4, :V5, :V6, :V7, :V8]))),
		32 => Enum.filter(@values, &(not(&1 in [:JokerRed, :JokerBlack, :V2, :V3, :V4, :V5, :V6]))),
		36 => Enum.filter(@values, &(not(&1 in [:JokerRed, :JokerBlack, :V2, :V3, :V4, :V5]))),
		52 => Enum.filter(@values, &(not(&1 in [:JokerRed, :JokerBlack]))),
		54 => @values
	}
	@spec values :: [Excards.value]
	def values, do: @values

	@type t :: %Excards{suit: Excards.suit, value: Excards.value}
	defstruct 	suit: nil,
				value: nil

	@type color :: :Red | :Black
	@spec color(Excards.t) :: color
	def color(%Excards{suit: suit}) when (suit in [:Hearts, :Diamonds]), do: :Red
	def color(%Excards{suit: suit}) when (suit in [:Spades, :Clubs]), do: :Black
	def color(%Excards{value: :JokerRed}), do: :Red
	def color(%Excards{value: :JokerBlack}), do: :Black

	############
	### deck ###
	############

	@type deck_type :: 24 | 32 | 36 | 52 | 54
	@spec new_deck(Excards.deck_type) :: [Excards.t]
	def new_deck(dt) do
		Map.get(@values_map, dt)
		|> Enum.map(fn
			value when (value in [:JokerRed, :JokerBlack]) -> %Excards{suit: nil, value: value}
			value -> Enum.map(@suits, fn(suit) -> %Excards{suit: suit, value: value} end)
		end)
		|> List.flatten
	end

end
