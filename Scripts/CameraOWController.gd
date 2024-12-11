extends Camera2D

@export var followPlayer: bool = false
var player
var lerpspeed = .05

func _ready() -> void:
	player = get_node("../PlayerOW")
	self.position = player.position     #Teleport camera to player position on scene start

# Smoothly lerp the camera to the player's position if set to follow
func _process(delta: float) -> void:
	if (followPlayer):
		self.position = lerp(self.position, player.position, lerpspeed)
