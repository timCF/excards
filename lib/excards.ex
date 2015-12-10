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

	#############
	### types ###
	#############

	@type suit :: :Hearts | :Spades | :Diamonds | :Clubs | :Joker
	@type value :: :V2 | :V3 | :V4 | :V5 | :V6 | :V7 | :V8 | :V9 | :V10 | :Jack | :Queen | :King | :Ace | :JokerRed | :JokerBlack
	@type color :: :Red | :Black
	@type deck_type :: 24 | 32 | 36 | 52 | 54

	@type t :: %Excards{suit: Excards.suit, value: Excards.value}
	defstruct 	suit: nil,
				value: nil

	#########################
	### compile-time data ###
	#########################

	@c_suits [:Hearts, :Spades, :Diamonds, :Clubs]
	@c_values [:V2, :V3, :V4, :V5, :V6, :V7, :V8, :V9, :V10, :Jack, :Queen, :King, :Ace, :JokerRed, :JokerBlack]

	##############
	### public ###
	##############

	@spec suits :: [Excards.suit]
	def suits, do: @c_suits

	@spec values :: [Excards.value]
	def values, do: @c_values

	@spec color(Excards.t) :: color
	def color(%Excards{suit: suit}) when (suit in [:Hearts, :Diamonds]), do: :Red
	def color(%Excards{suit: suit}) when (suit in [:Spades, :Clubs]), do: :Black
	def color(%Excards{value: :JokerRed}), do: :Red
	def color(%Excards{value: :JokerBlack}), do: :Black

end
