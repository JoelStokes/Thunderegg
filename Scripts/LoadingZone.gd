extends Area2D

@export var newScene: String = ""
var scenePath = "res://Scenes/"

func _on_body_entered(body):
	if (body.name == "PlayerOW"):
		get_tree().change_scene_to_file(scenePath + newScene + ".tscn")
