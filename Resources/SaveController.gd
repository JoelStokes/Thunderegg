extends Node

const SAVE_GAME_PATH := "user://savegame.tres"

var userSave = UserSave.new()

# Load game data on startup
func _ready() -> void:
	load_game()

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
	var data = ResourceSaver.save(userSave, SAVE_GAME_PATH)
	
	if data != OK:
		print("Error Saving Game: " + data)

func load_game():
	userSave = ResourceLoader.load(SAVE_GAME_PATH)
	
	if (userSave == null):
		print("Error loading game")
		userSave = UserSave.new()

# Item picked up, add the itemID and OWID to prevent repeat pickups. Add money if no itemID
func add_item(itemID, OWID, itemAmount:int = 0):
	var newValue = 1
	if (itemAmount):
		newValue = itemAmount

	if (itemID):
		var oldValue = userSave.Items[itemID]
		if (oldValue):
			newValue += int(oldValue)
		
		userSave.Items[itemID] = newValue
	else:
		userSave.money += newValue
		
	if (OWID):
		userSave.OWIDs[OWID] = 1                                      
	
	save_game()
	
func use_item(itemID, amount):
	userSave.Items[itemID] = userSave.Items[itemID] - 1
	save_game()

func load_specific(location, id : int = -1):
	if (!userSave):
		print("Error: No userSave data available for load call!")
		return 0
	
	# Check location. If exists, check ID at location. If no array at expected location, return 0
	var data
	var dataLocation = userSave.get(location)
	if (dataLocation):
		if (id != -1):
			data = dataLocation[id]
		else:
			data = userSave.get(location)
	else:
		# No position has been set yet, default to empty vector3
		return Vector3(0,0,0)
	return data

#Save OW level & location
func save_OW(newPos: Vector3, newScene):
	#Remove decimals from saved battle position
	userSave.lastPos = Vector3(roundf(newPos.x), roundf(newPos.y), roundf(newPos.z))
	
	#Trim Suffix added to make sure scene name isn't accidently saved with one
	userSave.lastScene = newScene.trim_suffix(".tscn")
	save_game()

#Save caught or seen Pokemon. Seen is 1, Caught is 2
func save_Dex(id, newStatus):
	userSave.Dex[id] = newStatus
	save_game()

#Save Main, SFX, and Music volumes
func save_Audio(main:float = -1.0, sfx:float = -1.0, music:float = -1.0):
	if (main >= 0):
		userSave.mainVolume = main
	if (sfx >= 0):
		userSave.sfxVolume = sfx
	if (music >= 0):
		userSave.musicVolume = music
	save_game()

#Remove previous save file to start from scratch
func delete_save():
	DirAccess.remove_absolute(SAVE_GAME_PATH)
	
	userSave = UserSave.new()
	save_game()
