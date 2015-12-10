defmodule Excards.Compile.Helper do

	#########################
	### compile-time data ###
	#########################

	@c_values_map %{
		24 => Enum.filter(Excards.values, &(not(&1 in [:JokerRed, :JokerBlack, :V2, :V3, :V4, :V5, :V6, :V7, :V8]))),
		32 => Enum.filter(Excards.values, &(not(&1 in [:JokerRed, :JokerBlack, :V2, :V3, :V4, :V5, :V6]))),
		36 => Enum.filter(Excards.values, &(not(&1 in [:JokerRed, :JokerBlack, :V2, :V3, :V4, :V5]))),
		52 => Enum.filter(Excards.values, &(not(&1 in [:JokerRed, :JokerBlack]))),
		54 => Excards.values
	}

	##############
	### public ###
	##############

	@spec new_deck(Excards.deck_type) :: [Excards.t]
	def new_deck(dt) do
		Map.get(@c_values_map, dt)
		|> Enum.map(fn
			value when (value in [:JokerRed, :JokerBlack]) -> %Excards{suit: :Joker, value: value}
			value -> Excards.suits |> Enum.map(fn(suit) -> %Excards{suit: suit, value: value} end)
		end)
		|> List.flatten
	end
end
