extends Area3D

@export var newScene: String = ""
@export var newPos:= Vector3(0,0,0)

@onready var cameraNode = get_node("/root/Scene/CameraOW")

# If touched by player, warp to new scene
func _on_body_entered(body):
	if (body.name == "PlayerOW"):
		cameraNode._change_scene(newScene, newPos)
