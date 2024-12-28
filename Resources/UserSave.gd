class_name UserSave
extends Resource

@export var name := "Blue"
@export var money := 0

#Used to load player position after game restart, battles, or travelling between scenes
@export var lastPos := Vector2(0,0)
@export var lastScene := ""

#Used to transition from overworld to battle
@export var isBattlePokemon := false
@export var wildPokemonID := 0
@export var wildPokemonLevel := 0
@export var wildTrainerID := 0

#Badges are saved as array so player can theoretically get a few out of order
@export var Badges = create_filled_int_array(8,0)

#Full list to check what the user has interacted with already. 10s place & onward split by town/route
@export var OWIDs = create_filled_int_array(99,0)

#How many Pokemon seen so far in adventure. 0 = not seen, 1 = seen, 2 = seen & caught, Sorted by PokeID
@export var Dex = create_filled_int_array(150,0)

#How many of each item is the player holding, sorted by ItemID
@export var Items = create_filled_int_array(50,0)

#Pokemon in Party
#@export var Party: Array[Pokemon] = []

func create_filled_int_array(p_initial_size: int, p_value: int) -> Array[int]:
	var new_arr: Array[int]
	new_arr.resize(p_initial_size)
	new_arr.fill(p_value)
	return new_arr
