extends TileMapLayer

const boundary_atlas_pos = Vector2i(1,0)
const cube_atlas_pos = Vector2i(2,0)
const main_source = 1
@export var layer: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	place_boundaries()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
	var higherNode = get_node_or_null("../Layer " + str(layer+1))
	if (higherNode):
		var higherUsed = higherNode.get_used_cells()
		for spot in higherUsed:
			if get_cell_source_id(spot):
				# Check if there's a block underneath. If not, do invisible collider. If yes, do self.
				# THIS NEEDS WORK! TODO
				if(get_cell_tile_data(spot-Vector2i(-1,-1)) == null):
					set_cell(spot-Vector2i(-1,-1), main_source, boundary_atlas_pos)
				else:
					set_cell(spot-Vector2i(-1,-1), main_source, boundary_atlas_pos)
					#set_cell(spot-Vector2i(-1,-1), main_source, get_cell_atlas_coords(spot))
