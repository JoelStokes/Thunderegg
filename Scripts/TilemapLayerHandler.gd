extends TileMapLayer

const boundary_atlas_pos = Vector2i(1,0)
const main_source = 1
@export var layer: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	place_boundaries()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Apply edge & layer collisions to tilemap layer
func place_boundaries():
	#Check adjacent tiles for open edge, then place colliders
	var offsets = [
		Vector2i(0,-1),
		Vector2i(0,1),
		Vector2i(1,0),
		Vector2i(-1,0)
	]
	var used = get_used_cells()
	for spot in used:
		for offset in offsets:
			var current_spot = spot + offset
			if get_cell_source_id(current_spot) == -1:
				set_cell(current_spot, main_source, boundary_atlas_pos)
	
	#Check next layer up to add collisions to base of higher blocks
	if (layer != 4):
		var higherUsed = get_node("../Layer " + str(layer+1)).get_used_cells()
		for spot in higherUsed:
			if get_cell_source_id(spot):
				set_cell(spot-Vector2i(-1,-1), main_source, boundary_atlas_pos)
