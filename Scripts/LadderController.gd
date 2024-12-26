extends Node2D

#collision layer to set player on exit to match new tile layer elevation
@export var bottomLayer: int = 1
@export var bottomZ: int = 1
@export var topLayer: int = 1
@export var topZ: int = 1
@export var bottomPos: Vector2 = Vector2.ZERO
@export var topPos: Vector2 = Vector2.ZERO

var playerInside = false
var player

var inBottom = false
var inTop = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Confirm")):
		if (inTop):
			player.position = bottomPos
			player.set_z_index(bottomZ)
			player.set_collision_mask_value(bottomLayer, true)
			player.set_collision_mask_value(topLayer, false)
			inTop = false
		elif (inBottom):
			player.position = topPos
			player.set_z_index(topZ)
			player.set_collision_mask_value(bottomLayer, false)
			player.set_collision_mask_value(topLayer, true)
			inBottom = false

# Set status of player in either the top or bottom regions
func _update_body_status(areaName, inside, pNode) -> void:
	player = pNode
	if (areaName == "TopArea"):
		inTop = inside
	else:
		inBottom = inside

'''func _set_position(areaName, newPos) -> void:
	if (areaName == "TopArea"):
		topPos = newPos
	else:
		bottomPos = newPos'''
