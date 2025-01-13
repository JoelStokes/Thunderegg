extends Node2D

var saveNode
var continueNode
var newTrainerTextbox

func _ready() -> void:
	saveNode = get_node("/root/SaveHandler")
	continueNode = $ContinueButton
	newTrainerTextbox = $TrainerNameBox
	
	saveNode.load_game()
	
	var trainerName = saveNode._get_name()
	if (trainerName):
		continueNode.text = "Continue: " + trainerName
	else:
		continueNode.queue_free()

# Play from loaded User Save
func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/isoTest.tscn")

#Start new User Save with new trainer name added
func _on_new_game_button_pressed() -> void:
	saveNode._set_name(newTrainerTextbox.text)
	get_tree().change_scene_to_file("res://Scenes/isoTest.tscn")
