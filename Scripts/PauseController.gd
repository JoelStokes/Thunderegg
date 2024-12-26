extends Control

var trainerNameNode
var itemTotalNode
var itemListNode
var pokemonTotalNode
var pokemonListNode
var lastPositionNode
var lastSceneNode
var playerNode
var saveNode

var itemFile = "res://Data/items.json"
var itemData

var paused = false

func _ready() -> void:
	#Get all pause menu text nodes
	trainerNameNode = $Trainer
	itemTotalNode = $Items
	itemListNode = $ItemList
	pokemonTotalNode = $Pokemon
	pokemonListNode = $PokemonList
	lastPositionNode = $LastPosition
	lastSceneNode = $LastScene
	
	playerNode = get_node("../../PlayerOW")
	saveNode = get_node("/root/SaveHandler")
	itemData = JSON.parse_string(FileAccess.get_file_as_string(itemFile))
	
	visible = false

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Pause")):
		_toggle_pause()

func _toggle_pause():
	paused = !paused
	
	if (paused):
		trainerNameNode.text = "Trainer: " + saveNode.load_specific("name")
		
		#Find & loop through all saved items for total count & individual counts
		var items = JSON.parse_string(saveNode.load_specific("items"))
		var itemTotal = 0
		if (items):
			for key in items.keys():
				if (itemListNode.text != ""):
					itemListNode.text += ", "
				itemListNode.text += itemData.get(key) + "(" + items[key] + ")"
				itemTotal += int(items[key])
		itemTotalNode.text = "Items Held: " + str(itemTotal)
		
		visible = true
		playerNode._set_freeze(true)
	else:
		visible = false
		playerNode._set_freeze(false)
