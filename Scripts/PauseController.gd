extends Control

@onready var trainerNameNode = $Trainer
@onready var moneyNode = $Money
@onready var itemTotalNode = $Items
@onready var itemListNode = $ItemList
@onready var dexTotalNode = $Pokemon
@onready var dexListNode = $PokemonList
@onready var lastPositionNode = $LastPosition
@onready var lastSceneNode = $LastScene
var playerNode
var saveNode

var itemFile = "res://Data/items.json"
var itemData
var pokemonFile = "res://Data/pokemon.json"
var pokemonData

var paused = false

func _ready() -> void:
	#Get nodes & data
	playerNode = get_node("../../PlayerOW")
	saveNode = get_node("/root/SaveHandler")
	itemData = JSON.parse_string(FileAccess.get_file_as_string(itemFile))
	pokemonData = JSON.parse_string(FileAccess.get_file_as_string(pokemonFile))

	visible = false

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Pause")):
		_toggle_pause()

func _toggle_pause():
	paused = !paused
	
	if (paused):
		trainerNameNode.text = "Trainer: " + str(saveNode.load_specific("name"))
		moneyNode.text = "Money: " + str(saveNode.load_specific("money")) + "$"

		#Find & loop through all saved items for total count & individual counts
		var items = saveNode.load_specific("Items")
		var itemTotal = 0
		itemListNode.text = "" #Remove initial N/A on empty item list
		for index in range(0,items.size()):
			if (items[index] != 0):
				if (itemListNode.text != ""):
					itemListNode.text += ", "
				itemListNode.text += str(itemData.get(str(index)).name) + "(" + str(items[index]) + ")"
				itemTotal += int(items[index])
		
		itemTotalNode.text = "Items Held: " + str(itemTotal)
		
		#Find & loop through all pokeDex values for total seen/caught
		var dex = saveNode.load_specific("Dex")
		var dexTotal = 0
		dexListNode.text = "" #Remove initial N/A on empty dex list
		for index in range(0,dex.size()):
			if (dex[index] > 1):
				if (dexListNode.text != ""):
					dexListNode.text += ", "
				print("index: " + str(index) + ", name: " + pokemonData.get(str(index)).name)
				dexListNode.text += str(pokemonData.get(str(index)).name)
				dexTotal += 1
		
		dexTotalNode.text = "Pokémon Caught: " + str(dexTotal)
		
		#Set Position & Scene
		lastPositionNode.text = "Last Position: " + str(saveNode.load_specific("lastPos"))
		lastSceneNode.text = "Last Scene: " + str(saveNode.load_specific("lastScene"))
		
		visible = true
		playerNode._set_freeze(true)
	else:
		visible = false
		playerNode._set_freeze(false)
