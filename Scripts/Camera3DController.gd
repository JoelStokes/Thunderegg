extends Camera3D

@export var followPlayer: bool = false
var player
var lerpspeed = .05
var saveNode
var startPos

func _ready() -> void:
	player = get_node("../PlayerOW")
	saveNode = get_node("/root/SaveHandler")
	startPos = self.position

	# Set player position if a non-zero save exists
	var lastX = saveNode.load_specific("lastPos", 0)
	var lastY = saveNode.load_specific("lastPos", 1)
	var lastZ = saveNode.load_specific("lastPos", 2)
	var lastPos = Vector3(lastX, lastY, lastZ)
	if (lastPos != Vector3.ZERO):
		player.position = lastPos

	# Teleport camera to player position on scene start so there's no weird, slow lerp
	self.position = Vector3(startPos.x + player.position.x, startPos.y + player.position.y, startPos.z + player.position.z)

# Smoothly lerp the camera to the player's position if set to follow
func _process(delta: float) -> void:
	if (followPlayer):
		self.position = lerp(self.position, Vector3(startPos.x + player.position.x, startPos.y + player.position.y, startPos.z + player.position.z), lerpspeed)
