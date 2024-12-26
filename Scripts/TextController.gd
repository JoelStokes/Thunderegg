extends Control

var textboxNode
var textArrowNode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textboxNode = $Textbox
	textArrowNode = $TextArrow
	visible = false

func _set_text(newText) -> void:
	textboxNode.text = newText
	textArrowNode.visible = false
	visible = true
	
func _hide_box() -> void:
	visible = false

func _show_text_end_icon() -> void:
	textArrowNode.visible = true
