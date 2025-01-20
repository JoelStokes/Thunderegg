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
	get_tree().change_scene_to_file("res://Scenes/" + saveNode.load_specific("lastScene") + ".tscn")

#Start new User Save with new trainer name added
func _on_new_game_button_pressed() -> void:
	saveNode.delete_save()
	
	if (newTrainerTextbox.text):
		saveNode._set_name(newTrainerTextbox.text)
	else:
		saveNode._set_name("Detective") #No name input, revert to default
	saveNode.save_OW(Vector3(309, 15, 1), "isoTest") #New Save starting location
	get_tree().change_scene_to_file("res://Scenes/isoTest.tscn")
