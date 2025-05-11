extends Area3D

@export var newScene: String = ""
@export var newPos:= Vector3(0,0,0)

var playerInside = false
@onready var cameraNode = get_node("/root/Scene/CameraOW")

# If user presses Confirm inside 
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Confirm")):
		if (playerInside):
			cameraNode._change_scene(newScene, newPos)

func _on_body_entered(body):
	if (body.name == "PlayerOW"):
		body._toggle_question(true)
		playerInside = true

func _on_body_exited(body):
	if (body.name == "PlayerOW"):
		body._toggle_question(false)
		playerInside = false
