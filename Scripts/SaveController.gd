extends Node2D

# Use Z axis as Z Depth to handle which layer player was on
var prevPlayerPos = Vector3.ZERO

# Wild Battle Management
var wildPokemonID = 0
var wildPokemonLevel = 0

func _get_wild_id() -> int:
	return wildPokemonID
	
func _get_wild_level() -> int:
	return wildPokemonLevel

func _set_wild_data(newID, newLevel) -> void:
	wildPokemonID = newID
	wildPokemonLevel = newLevel
