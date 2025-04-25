extends Area3D

## Wild Pokemon Array. x = ID, y = level minimum, z = level maximum
@export var pokemonIDS: Array[Vector3] = []
var battleScenePath = "res://Scenes/battle.tscn"
var encounterRate = 15      #Percent chance that battle will start when player enters
var saveNode

func _ready() -> void:
	saveNode = get_node("/root/SaveHandler")

func _on_body_entered(body: Node3D) -> void:
	if (body.name == "PlayerOW"):
		# Prevent chance of battle immediately starting on scene reload
		var lastPos = saveNode.load_specific("lastPos")
		if (Vector3(lastPos.x, lastPos.y, lastPos.z) != body.position):
			if (randi_range(0,99) <= encounterRate):
				var arrayPos = randi_range(0,pokemonIDS.size()-1)
				var newLevel = randi_range(pokemonIDS[arrayPos].y, pokemonIDS[arrayPos].z)
				saveNode._set_wild_data(pokemonIDS[arrayPos].x, newLevel)
				var sceneName = get_tree().get_current_scene().scene_file_path.get_file()
				saveNode.save_OW(Vector3(body.position.x, body.position.y, body.position.z), sceneName)
				get_tree().change_scene_to_file(battleScenePath)
