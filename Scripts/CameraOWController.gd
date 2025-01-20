extends Camera2D

@export var followPlayer: bool = false
var player
var lerpspeed = .05
var saveNode

func _ready() -> void:
	player = get_node("../PlayerOW")
	saveNode = get_node("/root/SaveHandler")
	
	# Get player's saved location and apply
	var lastPos = saveNode.load_specific("lastPos")
	var lastX = saveNode.load_specific("lastPos", 0)
	var lastY = saveNode.load_specific("lastPos", 1)
	var lastZ = saveNode.load_specific("lastPos", 2)
	
	player.position = Vector2(lastX, lastY)
	player.set_z_index(lastZ)
	
	# Set player's collision based on saved Z coordinate
	# Layer 1 = Player, 6 = Objects, 2-5 = Iso Terrain which changes based on current depth
	for n in range(1, 4):
		if (n == lastZ):
			player.set_collision_mask_value(n+1, true)
		else:
			player.set_collision_mask_value(n+1, false)

	# Teleport camera to player position on scene start so there's no weird, slow lerp
	self.position = player.position

# Smoothly lerp the camera to the player's position if set to follow
func _process(delta: float) -> void:
	if (followPlayer):
		self.position = lerp(self.position, player.position, lerpspeed)
