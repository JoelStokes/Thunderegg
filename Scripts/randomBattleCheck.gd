extends Area2D

## Wild Pokemon Array. x = ID, y = level minimum, z = level maximum
@export var pokemonIDS: Array[Vector3] = []
var battleScenePath = "res://Scenes/battle.tscn"
var encounterRate = 15      #Percent chance that battle will start when player enters
signal set_wild_data

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "PlayerOW"):
		if (randi_range(0,99) <= encounterRate):
			var arrayPos = randi_range(0,pokemonIDS.size()-1)
			var newLevel = randi_range(pokemonIDS[arrayPos].y, pokemonIDS[arrayPos].z)
			var saveNode = get_tree().get_nodes_in_group("Persist")
			set_wild_data.emit(pokemonIDS[arrayPos], newLevel)
			get_tree().change_scene_to_file(battleScenePath)
