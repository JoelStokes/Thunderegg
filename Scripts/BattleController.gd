extends Node2D

var saveNode

var id = "1"
var level = "1"

# Json data
var pokemonFile = "res://Data/pokemon.json"
var pokemonData

# Text Nodes
var nameNode
var sizeNode
var weightNode
var typeNode
var levelNode
var descriptionNode
var frontSpriteNode
var typeSpriteNode

func _ready() -> void:
	pokemonData = JSON.parse_string(FileAccess.get_file_as_string(pokemonFile))
	
	#Get ID & Level from previous scene saved info
	saveNode = get_node("../SaveHandler")
	level = str(saveNode._get_wild_level())
	id = str(saveNode._get_wild_id())
	
	#Set nodes to populate data
	nameNode = $UI/name
	sizeNode = $UI/size
	weightNode = $UI/weight
	typeNode = $UI/type
	levelNode = $UI/level
	descriptionNode = $UI/description
	frontSpriteNode = $FrontSprite
	typeSpriteNode = $TypeSprite
	
	#Apply text & image to nodes
	nameNode.text = "Name: " + pokemonData.get(id).name
	sizeNode.text = "Size: " + pokemonData.get(id).size
	weightNode.text = "Weight: " + pokemonData.get(id).weight
	typeNode.text = "Type: " + pokemonData.get(id).type
	levelNode.text = "Level: " + level
	descriptionNode.text = pokemonData.get(id).description
	frontSpriteNode.texture = load("res://Sprites/Pokemon/" + id + "front.png")
	typeSpriteNode.texture = load("res://Sprites/Types/" + pokemonData.get(id).type + ".png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Confirm") || Input.is_key_pressed(KEY_Z)):
		get_tree().change_scene_to_file("res://Scenes/isoTest.tscn")

# Need to look up proper saving & loading system
# persistant node not the best way?
