extends Node2D

var pokemonFile = "res://Data/pokemon.json"
var pokemonData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pokemonData = JSON.parse_string(FileAccess.get_file_as_string(pokemonFile))
	print(pokemonData.get("3").name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
