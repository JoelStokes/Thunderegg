extends Node2D

var saveNode

var id = 1
var level = 1
var dexStatus = 0

# Json data
var pokemonFile = "res://Data/pokemon.json"
var pokemonData

# Text Nodes
@onready var nameNode = $UI/name
@onready var sizeNode = $UI/size
@onready var weightNode = $UI/weight
@onready var levelNode = $UI/level
@onready var descriptionNode = $UI/description
@onready var frontSpriteNode = $FrontSprite
@onready var typeSpriteNode = $TypeSprite
@onready var caughtSpriteNode = $CaughtSprite
@onready var seenSpriteNode = $SeenSprite

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
	typeSpriteNode.texture = load("res://Sprites/Types/" + pokemonData.get(str(id)).type + ".png")

	#Set Seen & Caught sprites
	dexStatus = saveNode.load_specific("Dex", id)
	if (dexStatus > 0):
		seenSpriteNode.modulate = Color(1,1,1)
	if(dexStatus > 1):
		caughtSpriteNode.modulate = Color(1,1,1)

# Capture Pokemon, Save & return to previous scene
func _on_catch_button_down() -> void:
	if (dexStatus != 2):
		saveNode.save_Dex(id, 2)
	return_to_OW()

# Run away, save pokemon as seen but not captured. Return to previous scene
func _on_flee_button_down() -> void:
	if (dexStatus < 1):
		saveNode.save_Dex(id, 1)
	return_to_OW()

func return_to_OW():
	var scene = saveNode.load_specific("lastScene")
	get_tree().change_scene_to_file("res://Scenes/" + scene + ".tscn")
