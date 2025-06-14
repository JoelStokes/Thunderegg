extends Node3D

#Start Variables
var saveNode
@onready var selectBox = %SelectBox
@onready var continueNode = %ContinueButton
var newGameNode

#Debug Menu Variables
@onready var debugBox = %DebugBox
@onready var trainerNameTextbox = %TrainerNameBox
@onready var moneyTextbox = %MoneyBox
@onready var sceneTextbox = %SceneBox

#Debug Items
@onready var item1IDTextbox = %ItemID1
@onready var item1AmountTextbox = %Amount1
@onready var item2IDTextbox = %ItemID2
@onready var item2AmountTextbox = %Amount2
@onready var item3IDTextbox = %ItemID3
@onready var item3AmountTextbox = %Amount3

#Debug Pokemon in Party
@onready var poke1IDTextbox = %Poke1ID
@onready var poke1NameTextbox = %Poke1Name
@onready var poke1LevelTextbox = %Poke1Level
@onready var poke2IDTextbox = %Poke2ID
@onready var poke2NameTextbox = %Poke2Name
@onready var poke2LevelTextbox = %Poke2Level
@onready var poke3IDTextbox = %Poke3ID
@onready var poke3NameTextbox = %Poke3Name
@onready var poke3LevelTextbox = %Poke3Level

func _ready() -> void:
	saveNode = get_node("/root/SaveHandler")
	debugBox.hide()
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
	selectBox.hide()
	debugBox.show()

func _on_new_game_debug_pressed() -> void:
	saveNode.delete_save()
	
	if (moneyTextbox.text):
		saveNode.add_item(0, 0, int(moneyTextbox.text))
	
	if (item1IDTextbox.text && item1AmountTextbox):
		saveNode.add_item(int(item1IDTextbox.text), 0, int(item1AmountTextbox.text))
	if (item2IDTextbox.text && item2AmountTextbox):
		saveNode.add_item(int(item2IDTextbox.text), 0, int(item2AmountTextbox.text))
	if (item3IDTextbox.text && item3AmountTextbox):
		saveNode.add_item(int(item3IDTextbox.text), 0, int(item3AmountTextbox.text))
	
	#Trainer Name
	if (trainerNameTextbox.text):
		saveNode._set_name(trainerNameTextbox.text)
	else:
		saveNode._set_name("Ace") #No name input, revert to default
	
	#New Save starting location
	var firstScene
	if (sceneTextbox.text):
		saveNode.save_OW(Vector3(0,0,0), sceneTextbox.text)
		firstScene = sceneTextbox.text
	else:
		firstScene =  "OW_test"
		saveNode.save_OW(Vector3(0,0,0), firstScene)
	
	get_tree().change_scene_to_file("res://Scenes/" + firstScene + ".tscn")
