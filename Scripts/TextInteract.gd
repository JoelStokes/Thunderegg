extends Area2D

#Trigger Dialog if player walks into area and presses interact
@export_multiline var textArray: Array[String] = []
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textNode = get_node("../CameraOW/Text Parent")
	playerNode = get_node("../PlayerOW")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Confirm") || Input.is_key_pressed(KEY_Z)):
		if (inZone):
			#Start Dialog Box
			if (!dialogStarted):
				currLetter = 1
				textNode._set_text(textArray[currArrayPos].substr(0,currLetter))
				playerNode._set_freeze(true)
				dialogStarted = true
				textFinished = false
				
			#Advance to next text block or end if full array traversed
			elif (textFinished):
				if (currArrayPos >= textArray.size()-1):
					textNode._hide_box()
					playerNode._set_freeze(false)
					dialogStarted = false
					currArrayPos = 0
				else:
					currLetter = 1
					currArrayPos += 1
					textFinished = false
					textNode._set_text(textArray[currArrayPos].substr(0,currLetter))
			#Text is still scrolling, immediately finish text scroll
			else:
				textNode._set_text(textArray[currArrayPos])
				textFinished = true
				textNode._show_text_end_icon()
	
	if (!textFinished):
		textCounter += delta
		if (textCounter > textLim):
			if (currLetter < textArray[currArrayPos].length()):
				currLetter += 1
				textNode._set_text(textArray[currArrayPos].substr(0,currLetter))
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