extends Area2D

@export var newScene: String = ""
@export var newPos:= Vector3(0,0,0)

var scenePath = "res://Scenes/"
var saveNode

func _ready() -> void:
	saveNode = get_node("/root/SaveHandler")
	
	#Set item trigger collisions to match layer to prevent impossible item grabs
	set_collision_mask_value(z_index+1, true)
	set_collision_layer_value(z_index+1, true)

# If touched by player, warp to new scene
func _on_body_entered(body):
	if (body.name == "PlayerOW"):
		saveNode.save_OW(newPos, newScene)
		get_tree().change_scene_to_file(scenePath + newScene + ".tscn")
