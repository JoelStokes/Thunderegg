extends Area2D

@export var newScene: String = ""
@export var newPos:= Vector3(0,0,0)

var scenePath = "res://Scenes/"
var playerInside = false
var saveNode

func _ready() -> void:
	saveNode = get_node("/root/SaveHandler")
	
	#Set item trigger collisions to match layer to prevent impossible item grabs
	set_collision_mask_value(z_index+1, true)
	set_collision_layer_value(z_index+1, true)

# If user presses Confirm inside 
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Confirm")):
		if (playerInside):
			saveNode.save_OW(newPos, newScene)
			get_tree().change_scene_to_file(scenePath + newScene + ".tscn")

func _on_body_entered(body):
	if (body.name == "PlayerOW"):
		playerInside = true

func _on_body_exited(body):
	if (body.name == "PlayerOW"):
		playerInside = false
