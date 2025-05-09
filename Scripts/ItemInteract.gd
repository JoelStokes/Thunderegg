extends Area3D

#Trigger Dialog if player walks into area and presses interact
#OWID handles collection status of item (prevent appearing if already collected)
@export var OWID = 0
@export var itemID = 0
var inZone = false
var dialogStarted = false
var textNode
var playerNode
var saveNode

var itemFile = "res://Data/items.json"
var itemData

#Text scrolling variables
var itemText = ""
var currLetter = 0
var currArrayPos = 0
var textLim = .04     #Amount of seconds until next letter revealed
var textCounter = 0
var textFinished = true

func _ready() -> void:
	textNode = get_node("../CameraOW/DialogBox")
	playerNode = get_node("../PlayerOW")
	saveNode = get_node("/root/SaveHandler")
	
	#Check if the player has already collected this item previously
	var checkCollected = saveNode.load_specific("OWIDs", OWID)
	if (checkCollected):
		queue_free()
	
	itemData = JSON.parse_string(FileAccess.get_file_as_string(itemFile))
	var itemName = itemData.get(str(itemID)).get("name")
	itemText = "You found a " + itemName + "!"
	
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Confirm")):
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
				saveNode.add_item(itemID, OWID)
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

func _on_body_entered(body: Node3D) -> void:
	if (body.name == "PlayerOW"):
		body._toggle_question(true)
		inZone = true

func _on_body_exited(body: Node3D) -> void:
	if (body.name == "PlayerOW"):
		body._toggle_question(false)
		inZone = false
