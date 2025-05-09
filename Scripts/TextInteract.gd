extends Area3D

#Trigger Dialog if player walks into area and presses interact
@export_multiline var textArray: Array[String] = []
@export_multiline var altTextArray: Array[String] = []	#Alt text used when item already collected
@export var itemOWID: int
@export var itemID: int
@export var itemAmount: int #If Item amount but no itemID, add it to money
var inZone = false
var dialogStarted = false
var textNode
var playerNode

#Text scrolling variables
var currLetter = 0
var currArrayPos = 0
var textLim = .04     #Amount of seconds until next letter revealed
var textCounter = 0
var textFinished = true

#Save Node Access / Item Management
var saveNode
var useAltText = false
var currTextArray

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textNode = get_node("../CameraOW/DialogBox")
	playerNode = get_node("../PlayerOW")

	# If item given from interaction, check if the player has already recieved it
	if (itemOWID):
		saveNode = get_node("/root/SaveHandler")
		if (saveNode.load_specific("OWIDs", itemOWID) > 0):
			useAltText = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Confirm") || Input.is_key_pressed(KEY_Z)):
		if (inZone):
			if (useAltText):
				currTextArray = altTextArray
			else:
				currTextArray = textArray
			
			#Start Dialog Box
			if (!dialogStarted):
				currLetter = 1
				textNode._set_text(currTextArray[currArrayPos].substr(0,currLetter))
				playerNode._set_freeze(true)
				dialogStarted = true
				textFinished = false
				
			#Advance to next text block or end if full array traversed
			elif (textFinished):
				if (currArrayPos >= currTextArray.size()-1):
					if (itemAmount && !useAltText):
						_add_item()
					textNode._hide_box()
					playerNode._set_freeze(false)
					dialogStarted = false
					currArrayPos = 0
					
					#If there's alternate text, switch to use it for next read
					if (altTextArray):
						useAltText = true
				else:
					currLetter = 1
					currArrayPos += 1
					textFinished = false
					textNode._set_text(currTextArray[currArrayPos].substr(0,currLetter))
			#Text is still scrolling, immediately finish text scroll
			else:
				textNode._set_text(currTextArray[currArrayPos])
				textFinished = true
				textNode._show_text_end_icon()
	
	if (!textFinished):
		textCounter += delta
		if (textCounter > textLim):
			if (currLetter < currTextArray[currArrayPos].length()):
				currLetter += 1
				textNode._set_text(currTextArray[currArrayPos].substr(0,currLetter))
			else:
				textFinished = true
				textNode._show_text_end_icon()
			textCounter = 0

func _add_item():
	saveNode.add_item(itemID, itemOWID, itemAmount)

func _on_body_entered(body):
	if (body.name == "PlayerOW"):
		body._toggle_question(true)
		inZone = true

func _on_body_exited(body):
	if (body.name == "PlayerOW"):
		body._toggle_question(false)
		inZone = false
