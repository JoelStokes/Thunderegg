extends Camera3D

var changingScene = false
var fadingIn = true
var sceneToLoad = ""
var scenePath = "res://Scenes/"

# Shader Scene Transition Variables
@onready var material = $CanvasLayer/ColorRect.get_material()
var shaderProgress = 0
var shaderSpeed = 1
var startFreezeLength = .5
var startFreezeTimer = 0
var startFreezeEnded = false

func _ready() -> void:
	# Set previous shader back to Fade In at 0% Complete
	material.set_shader_parameter("fadeOut", false)
	material.set_shader_parameter("progress", 0)

func _process(delta: float) -> void:
	if (changingScene || fadingIn):
		shaderProgress += shaderSpeed * delta
		
		if (shaderProgress >= 1):
			material.set_shader_parameter("progress", 1)
			if (changingScene):
				get_tree().change_scene_to_file(sceneToLoad)
		else:
			material.set_shader_parameter("progress", shaderProgress)

# Start the attached scene change shader & save new scene / player position
func _change_scene(newScene, newPos) -> void:
	changingScene = true
	material.set_shader_parameter("fadeOut", true)
	material.set_shader_parameter("progress", 0)
	shaderProgress = 0
	sceneToLoad = scenePath + newScene + ".tscn"
