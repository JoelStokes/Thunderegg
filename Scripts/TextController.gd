extends Control

@onready var textboxNode = $Textbox
@onready var textArrowNode = $TextArrow

func _ready() -> void:
	visible = false

func _set_text(newText) -> void:
	textboxNode.text = newText
	textArrowNode.visible = false
	visible = true
	
func _hide_box() -> void:
	visible = false

func _show_text_end_icon() -> void:
	textArrowNode.visible = true
