extends Camera2D

@export var followPlayer: bool = false
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../PlayerOW")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (followPlayer):
		self.position = player.position
