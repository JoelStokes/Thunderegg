extends Node2D

#collision layer to set player on exit to match new tile layer elevation
@export var lowerLayer: int = 0
@export var lowerZ: int = 0
@export var higherLayer: int = 0
@export var higherZ: int = 0

var playerInside = false
var player

var bottomPos = Vector2i(0,0)
var topPos = Vector2i(0,0)
var inBottom = false
var inTop = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Confirm") || Input.is_key_pressed(KEY_Z)):
		if (inTop):
			player.position = bottomPos
			player.set_z_index(lowerZ)
			player.set_collision_mask_value(lowerLayer, true)
			player.set_collision_mask_value(higherLayer, false)
			inTop = false
		elif (inBottom):
			player.position = topPos
			player.set_z_index(higherZ)
			player.set_collision_mask_value(lowerLayer, false)
			player.set_collision_mask_value(higherLayer, true)
			inBottom = false

# Set status of player in either the top or bottom regions
func _update_body_status(areaName, inside, pNode) -> void:
	player = pNode
	if (areaName == "TopArea"):
		inTop = inside
	else:
		inBottom = inside

func _set_position(areaName, newPos) -> void:
	if (areaName == "TopArea"):
		topPos = newPos
	else:
		bottomPos = newPos
