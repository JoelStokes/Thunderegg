extends Node2D

#Collision layer to set player on exit to match new tile layer elevation
var bottomLayer: int = 1
var topLayer: int = 1

#Player position checks for ladder interaction
var playerInside = false
var player
var inBottom = false
var inTop = false

#Adjustment applied to player ladder exit position, changes based on positive or negative ladder scaling (facing left or right)
var topAdjust
var bottomAdjust
var bottomMask
var topMask
var topAdjustPos = Vector2(2, 7)
var topAdjustNeg = Vector2(-10, 16)
var bottomAdjustPos = Vector2(2, 12)
var bottomAdjustNeg = Vector2(0, 10)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bottomLayer = z_index 
	topLayer = $Top.z_index + 1
	bottomMask = bottomLayer + 1
	topMask = topLayer + 1
	
	#Check if ladder is flipped on Y axis
	if (scale.y < 0):
		topAdjust = topAdjustNeg
		bottomAdjust = bottomAdjustNeg
	else:
		topAdjust = topAdjustPos
		bottomAdjust = bottomAdjustPos

	#Set bottom & top trigger collisions to match layer to prevent impossible ladder grabs
	$BottomArea.set_collision_mask_value(bottomMask, true)
	$TopArea.set_collision_mask_value(topMask, true)
	$BottomArea.set_collision_layer_value(bottomMask, true)
	$TopArea.set_collision_layer_value(topMask, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Confirm")):
		if (inTop):
			player.position = $BottomArea/CollisionPolygon2D.global_position + bottomAdjust
			player.set_z_index(bottomLayer)
			player.set_collision_mask_value(bottomMask, true)
			player.set_collision_layer_value(bottomMask, true)
			player.set_collision_mask_value(topMask, false)
			player.set_collision_layer_value(topMask, false)
			inTop = false
		elif (inBottom):
			player.position = $TopArea/CollisionPolygon2D.global_position + topAdjust
			player.set_z_index(topLayer)
			player.set_collision_mask_value(bottomMask, false)
			player.set_collision_layer_value(bottomMask, false)
			player.set_collision_mask_value(topMask, true)
			player.set_collision_layer_value(topMask, true)
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
