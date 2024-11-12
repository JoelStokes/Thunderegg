extends Area2D

@export var pokemonIDS: Array[int] = []
var battleScenePath = "res://Scenes/battle.tscn"
var encounterRate = 15      #Percent chance that battle will start when player enters

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "PlayerOW"):
		if (randi_range(0,99) <= encounterRate):
			get_tree().change_scene_to_file(battleScenePath)
