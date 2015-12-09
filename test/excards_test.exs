defmodule ExcardsTest do
	use ExUnit.Case
	doctest Excards

	test "decks" do
		assert Enum.all?([24, 32, 36, 52, 54], &((Excards.new_deck(&1) |> length) == &1))
	end
end
