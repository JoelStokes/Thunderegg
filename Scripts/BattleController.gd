extends Node2D

var saveNode

var id = 1
var level = 1
var dexStatus = 0
var canCatch = false

# Json data
var pokemonFile = "res://Data/pokemon.json"
var pokemonData

# Text, Sprite, and Button Nodes
@onready var nameNode = $UI/name
@onready var sizeNode = $UI/size
@onready var weightNode = $UI/weight
@onready var levelNode = $UI/level
@onready var descriptionNode = $UI/description
@onready var frontSpriteNode = $FrontSprite
@onready var typeSpriteNode = $TypeSprite
@onready var typeSprite2Node = $TypeSprite2
@onready var caughtSpriteNode = $CaughtSprite
@onready var seenSpriteNode = $SeenSprite
@onready var catchButtonNode = $CatchButton

func _ready() -> void:
	pokemonData = JSON.parse_string(FileAccess.get_file_as_string(pokemonFile))
	
	#Get ID & Level from previous scene saved info
	saveNode = get_node("../SaveHandler")
	level = saveNode._get_wild_level()
	id = saveNode._get_wild_id()
	
	#Apply text & image to nodes
	nameNode.text = "A wild " + pokemonData.get(str(id)).name + " appeared!"
	sizeNode.text = "Size: " + pokemonData.get(str(id)).size
	weightNode.text = "Weight: " + pokemonData.get(str(id)).weight
	levelNode.text = "Lv: " + str(level)
	descriptionNode.text = pokemonData.get(str(id)).description
	frontSpriteNode.texture = load("res://Sprites/Pokemon/" + str(id) + "front.png")
	
	# Get Type(s), hide 2nd sprite if only 1 type
	var typeString = pokemonData.get(str(id)).type
	if (typeString.contains("/")):
		var type1 = typeString.substr(0,(typeString.find("/")))
		var type2 = typeString.substr((typeString.find("/")+1))
		typeSpriteNode.texture = load("res://Sprites/Types/" + type1 + ".png")
		typeSprite2Node.texture = load("res://Sprites/Types/" + type2 + ".png")
	else:
		typeSpriteNode.texture = load("res://Sprites/Types/" + typeString + ".png")
		typeSprite2Node.modulate = Color(1,1,1,0)

	#Set Seen & Caught sprites
	dexStatus = saveNode.load_specific("Dex", id)
	if (dexStatus > 0):
		seenSpriteNode.modulate = Color(1,1,1)
	if(dexStatus > 1):
		caughtSpriteNode.modulate = Color(1,1,1)
	
	#Check if pokeballs in inventory to enable catch option
	if (saveNode.load_specific("Items", 2) > 0):
		canCatch = true
	else:
		catchButtonNode.modulate = Color(.5,.5,.5,.5)

# Capture Pokemon, Save & return to previous scene
func _on_catch_button_down() -> void:
	if (canCatch):
		if (dexStatus != 2):
			saveNode.save_Dex(id, 2)
		saveNode.use_item(2, 1) #Subtract 1 pokeball
		return_to_OW()

# Run away, save pokemon as seen but not captured. Return to previous scene
func _on_flee_button_down() -> void:
	if (dexStatus < 1):
		saveNode.save_Dex(id, 1)
	return_to_OW()

func return_to_OW():
	var scene = saveNode.load_specific("lastScene")
	get_tree().change_scene_to_file("res://Scenes/" + scene + ".tscn")
