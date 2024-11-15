extends Node2D

var saveNode

var id
var level

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
var spriteNode

func _ready() -> void:
	pokemonData = JSON.parse_string(FileAccess.get_file_as_string(pokemonFile))
	
	#Get ID & Level from previous scene saved info
	var saveNode = get_tree().get_nodes_in_group("Persist")
	id = saveNode._get_wild_id
	level = saveNode._get_wild_level
	
	#Set nodes
	nameNode = $UI/name
	sizeNode = $UI/size
	weightNode = $UI/weight
	typeNode = $UI/type
	levelNode = $UI/level
	descriptionNode = $UI/description
	spriteNode = $Sprite2D
	
	#Set text & image
	nameNode.text = "Name: " + pokemonData.get(id).name
	sizeNode.text = "Size: " + pokemonData.get(id).size
	weightNode.text = "Weight: " + pokemonData.get(id).weight
	typeNode.text = "Type: " + pokemonData.get(id).type
	levelNode.text = "Level: " + level
	descriptionNode.text = pokemonData.get(id).description
	spriteNode.texture = load("res://Sprites/Pokemon/" + id + "front.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Need to look up proper saving & loading system
# persistant node not the best way?