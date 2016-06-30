defmodule Excards.Games.Poker.Holdem do

	#############
	### types ###
	#############

	@type period :: :Preflop | :Flop | :Turn | :River
	@type t :: %Excards.Games.Poker.Holdem{period: period, cards_players: [[Excards.t]], cards_commons: [Excards.t]}
	defstruct	deck: nil,
				period: nil,
				cards_players: nil,
				cards_commons: nil,
				players_bestcombo: %{},
				players_win_tie: %{},
				sumrounds: 0


	#########################
	### compile-time data ###
	#########################

	@new_deck Excards.Deck.new(52)

	##############
	### public ###
	##############

	@spec new( 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 ) :: Excards.Games.Poker.Holdem.t
	def new(pn) when is_integer(pn) and (pn > 0) and (pn < 9) do
		Enum.reduce(1..pn, %Excards.Games.Poker.Holdem{period: :Preflop, deck: Excards.Deck.shuffle(@new_deck), cards_players: [], cards_commons: []},
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

	def eval(state = %Excards.Games.Poker.Holdem{deck: deck}), do: eval_proc(state, (Stream.with_index(deck) |> Enum.reduce(%{}, fn({c,i},acc) -> Map.put(acc, i, c) end)))

	defp eval_proc(state = %Excards.Games.Poker.Holdem{cards_commons: [_,_,_,_,_], sumrounds: sumrounds}, %{}) do
		#
		# TODO
		#
		%Excards.Games.Poker.Holdem{state | sumrounds: sumrounds + 1}
	end
	defp eval_proc(state = %Excards.Games.Poker.Holdem{cards_commons: cards_commons}, deckmap = %{}) do
		Enum.reduce(deckmap, state, fn({n, _}, acc = %Excards.Games.Poker.Holdem{}) ->
			%Excards.Games.Poker.Holdem{acc | cards_commons: [Map.get(deckmap, n)|cards_commons]}
			|> eval_proc(Map.delete(deckmap, n))
		end)
	end

end
