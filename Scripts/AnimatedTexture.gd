extends MeshInstance3D

@export var images : Array[ImageTexture] = []
@export var lim = 1
var timer = 0
var currImage = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if (timer > lim):
		timer = 0
		currImage += 1
		if (currImage >= images.size):
			currImage = 0
		self.Material.Texture = images[currImage]
