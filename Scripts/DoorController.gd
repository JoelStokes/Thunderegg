extends Area2D

@export var newScene: String = ""
var scenePath = "res://Scenes/"
var playerInside = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Confirm") || Input.is_key_pressed(KEY_Z)):
		if (playerInside):
			get_tree().change_scene_to_file(scenePath + newScene + ".tscn")

func _on_body_entered(body):
	if (body.name == "PlayerOW"):
		playerInside = true

func _on_body_exited(body):
	if (body.name == "PlayerOW"):
		playerInside = false
