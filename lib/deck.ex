defmodule Excards.Deck do

	#########################
	### compile-time data ###
	#########################

	@c_deck_24 Excards.Compile.Helper.new_deck(24)
	@c_deck_32 Excards.Compile.Helper.new_deck(32)
	@c_deck_36 Excards.Compile.Helper.new_deck(36)
	@c_deck_52 Excards.Compile.Helper.new_deck(52)
	@c_deck_54 Excards.Compile.Helper.new_deck(54)

	##############
	### public ###
	##############

	@spec new(Excards.deck_type) :: [Excards.t]
	def new(24), do: @c_deck_24
	def new(32), do: @c_deck_32
	def new(36), do: @c_deck_36
	def new(52), do: @c_deck_52
	def new(54), do: @c_deck_54

	@spec shuffle([Excards.t]) :: [Excards.t]
	def shuffle(lst), do: Randomex.shuffle(lst)

	@spec take([Excards.t], pos_integer) :: {[Excards.t],[Excards.t]}
	def take([h|t],1), do: {[h],t}
	def take(deck = [_|_], n) when (is_integer(n) and (n > 1) and (n <= length(deck))), do: Enum.split(deck,n)

end
