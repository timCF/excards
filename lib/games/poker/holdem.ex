defmodule Excards.Games.Poker.Holdem do

	#############
	### types ###
	#############

	@type period :: :Preflop | :Flop | :Turn | :River
	@type t :: %Excards.Games.Poker.Holdem{period: period, cards_players: [[Excards.t]], cards_commons: [Excards.t]}
	defstruct	deck: nil,
				period: nil,
				cards_players: nil,
				cards_commons: nil

	#########################
	### compile-time data ###
	#########################

	@new_deck Excards.Deck.new(36)

	##############
	### public ###
	##############

	@spec new( 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 ) :: Excards.Games.Poker.Holdem.t
	def new(pn) when is_integer(pn) and (pn > 0) and (pn < 9) do
		Enum.reduce(0..pn, %Excards.Games.Poker.Holdem{period: :Preflop, deck: Excards.Deck.shuffle(@new_deck), cards_players: [], cards_commons: []},
			fn(_, state = %Excards.Games.Poker.Holdem{deck: this_deck, cards_players: cp}) ->
				{new_cards, new_deck} = Excards.Deck.take(this_deck, 2)
				%Excards.Games.Poker.Holdem{state | deck: new_deck, cards_players: [new_cards|cp]}
			end)
	end

	@spec play(Excards.Games.Poker.Holdem.t) :: Excards.Games.Poker.Holdem.t
	def play(state = %Excards.Games.Poker.Holdem{period: :Preflop, deck: this_deck}) do
		{new_cards, new_deck} = Excards.Deck.take(this_deck, 3)
		%Excards.Games.Poker.Holdem{state | period: :Flop, cards_commons: new_cards, deck: new_deck}
	end
	def play(state = %Excards.Games.Poker.Holdem{period: period, deck: this_deck, cards_commons: cards_commons}) do
		{new_cards, new_deck} = Excards.Deck.take(this_deck, 1)
		%Excards.Games.Poker.Holdem{state | period: (case period do ; :Flop -> :Turn ; :Turn -> :River ; end),
											cards_commons: (cards_commons ++ new_cards),
											deck: new_deck}
	end

end
