extends Area3D

@export var newScene: String = ""
@export var newPos:= Vector3(0,0,0)

var scenePath = "res://Scenes/"
var saveNode

func _ready() -> void:
	saveNode = get_node("/root/SaveHandler")

# If touched by player, warp to new scene
func _on_body_entered(body):
	if (body.name == "PlayerOW"):
		saveNode.save_OW(newPos, newScene)
		get_tree().change_scene_to_file.call_deferred(scenePath + newScene + ".tscn")
