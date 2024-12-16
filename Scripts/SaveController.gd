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

#Pass specific json path & value to save
func save_specific(location, value):
	var file = FileAccess.open("user://savegame.data", FileAccess.WRITE)
	
	var saved_data = {}
	saved_data[location] = value
	
	var json = JSON.stringify(saved_data)
	
	file.store_string(json)
	file.close()

func load_specific(location) -> string:
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)

	var json = file.get_as_text()
	var saved_data = JSON.parse_string(json)

	var value = saved_data.get(location)

	return value


#Save OW position
func save_OW(newX, newY, scene):
	var file = FileAccess.open("user://savegame.data", FileAccess.WRITE)
	
	var saved_data = {}
	
	saved_data["OW:Position:x"] = newX
	saved_data["OW:Position:y"] = newY
	saved_data["OW:Scene"] = scene
	
	var json = JSON.stringify(saved_data)
	
	file.store_string(json)
	file.close()

func load_game():
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)

	var json = file.get_as_text()
	
	var saved_data = JSON.parse_string(json)
	
	file.close()
