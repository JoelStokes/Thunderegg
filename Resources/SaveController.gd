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
	
func _get_name() -> String:
	if (userSave):
		return userSave.name
	else:
		return ""

func _set_name(newName) -> void:
	userSave.name = newName
	save_game()

func save_game():
	#var userSave:UserSave = UserSave.new()
	ResourceSaver.save(userSave, SAVE_GAME_PATH)

static func load_game() -> Resource:
	if not ResourceLoader.has_cached(SAVE_GAME_PATH):
		ResourceLoader.load(SAVE_GAME_PATH,"", true)
	# From existing bug? See https://www.youtube.com/watch?v=TGdQ57qCCF0 for info
	# Also check out https://forum.godotengine.org/t/how-to-create-a-shader-for-casting-shadows-on-an-isometric-tilemap/11234
	# Shadows for Isometric world?
	
	var file := File.new()
	if file.open(SAVE_GAME_PATH, File.READ) != OK:
		printerr("Couldn't read file " + SAVE_GAME_PATH)
		return null
		
	var data := file.get_as_text()
	file.close()
	#FINISH THIS SECTION FROM ABOVE VIDEO LINK!
	
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
