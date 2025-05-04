extends Area3D

@export var newScene: String = ""
@export var newPos:= Vector3(0,0,0)

var scenePath = "res://Scenes/"
var playerInside = false
var saveNode

func _ready() -> void:
	saveNode = get_node("/root/SaveHandler")

# If user presses Confirm inside 
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Confirm")):
		if (playerInside):
			saveNode.save_OW(newPos, newScene)
			get_tree().change_scene_to_file(scenePath + newScene + ".tscn")

func _on_body_entered(body):
	if (body.name == "PlayerOW"):
		body._toggle_question(true)
		playerInside = true

func _on_body_exited(body):
	if (body.name == "PlayerOW"):
		body._toggle_question(false)
		playerInside = false
