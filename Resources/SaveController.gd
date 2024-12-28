extends Node

const SAVE_GAME_PATH := "user://savegame.tres"

@export var userSave: Resource

func _get_wild_id() -> int:
	return userSave.wildPokemonID
	
func _get_wild_level() -> int:
	return userSave.wildPokemonLevel

func _set_wild_data(newID, newLevel) -> void:
	userSave.wildPokemonID = newID
	userSave.wildPokemonLevel = newLevel
	save_game()

func save_game():
	var userSave:UserSave = UserSave.new()
	ResourceSaver.save(userSave, SAVE_GAME_PATH)

static func load_game():
	var userSave:UserSave = load(SAVE_GAME_PATH) as UserSave

func add_item(itemID, OWID):
	var newValue = 1

	var oldValue = userSave.items[itemID]
	if (oldValue):
		newValue += int(oldValue)
	
	userSave.Items[itemID] = newValue
	
	if (OWID):
		userSave.OWID[OWID] = 1
	
	save_game()

func load_specific(location, id : int = 0):
	load_game()
	if (!userSave):
		return 0
	
	var data
	if (id != 0):
		data = userSave.get(location)[id]
	else:
		data = userSave.get(location)
	return data

#Save OW position
func save_OW(newX, newY, scene):
	load_game()
	userSave.lastPos = Vector2(newX, newY)
	userSave.lastScene = scene
