extends Area2D

#Trigger Dialog if player walks into area and presses interact
@export var itemID: int = 0
var inZone = false
var dialogStarted = false
var textNode
var playerNode

var itemFile = "res://Data/items.json"
var itemData

#Text scrolling variables
var itemText
var currLetter = 0
var currArrayPos = 0
var textLim = .04     #Amount of seconds until next letter revealed
var textCounter = 0
var textFinished = true

func _ready() -> void:
	#Check if the player has collected the item to decide if it exists or not
	textNode = get_node("../CameraOW/Text Parent")
	playerNode = get_node("../PlayerOW")
	
	itemData = JSON.parse_string(FileAccess.get_file_as_string(itemFile))
	itemText = "You found a " + itemData.get(itemID).name + "!"

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Confirm") || Input.is_key_pressed(KEY_Z)):
		if (inZone):
			#Start Dialog Box
			if (!dialogStarted):
				currLetter = 1
				textNode._set_text(itemText.substr(0,currLetter))
				playerNode._set_freeze(true)
				dialogStarted = true
				textFinished = false
				
			#Advance to next text block or end if full array traversed
			elif (textFinished):
				textNode._hide_box()
				playerNode._set_freeze(false)
				dialogStarted = false
				currArrayPos = 0
				queue_free()	#destroys self and all children
				
			#Text is still scrolling, immediately finish text scroll
			else:
				textNode._set_text(itemText)
				textFinished = true
				textNode._show_text_end_icon()
	
	if (!textFinished):
		textCounter += delta
		if (textCounter > textLim):
			if (currLetter < itemText.length()):
				currLetter += 1
				textNode._set_text(itemText.substr(0,currLetter))
			else:
				textFinished = true
				textNode._show_text_end_icon()
			textCounter = 0

func _on_body_entered(body):
	if (body.name == "PlayerOW"):
		inZone = true

func _on_body_exited(body):
	if (body.name == "PlayerOW"):
		inZone = false