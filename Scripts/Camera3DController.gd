extends Camera3D

@export var followPlayer: bool = false
var player
var lerpspeed = .05
var saveNode
var startPos
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
	player = get_node("../PlayerOW")
	saveNode = get_node("/root/SaveHandler")
	startPos = self.position

	# Set player position if a non-zero save exists
	var lastPos = saveNode.load_specific("lastPos")
	if (lastPos is int):	#Prevent error in cases where a 0 position was passed
		print("Error! No Location Set! Defaulting to 0,0,0")
		lastPos = Vector3.ZERO
	if (lastPos != Vector3.ZERO):
		player.position = lastPos
		
	# Set previous shader back to Fade In at 0% Complete
	material.set_shader_parameter("fadeOut", false)
	material.set_shader_parameter("progress", 0)

	# Teleport camera to player position on scene start (if follow) so there's no weird, slow lerp
	if (followPlayer):
		self.position = Vector3(startPos.x + player.position.x, startPos.y + player.position.y, startPos.z + player.position.z)

	# Freeze player (if there is a player) until scene start shader animation finished
	player._set_freeze(true)

# Smoothly lerp the camera to the player's position if set to follow
func _process(delta: float) -> void:
	if (followPlayer):
		self.position = lerp(self.position, Vector3(startPos.x + player.position.x, startPos.y + player.position.y, startPos.z + player.position.z), lerpspeed)
	if (changingScene || fadingIn):
		shaderProgress += shaderSpeed * delta
		
		# Handle initial player freeze on scene load
		if (!startFreezeEnded):
			if (startFreezeTimer < startFreezeLength):
				startFreezeTimer += delta
			else:
				startFreezeEnded = true
				player._set_freeze(false)
		
		if (shaderProgress >= 1):
			material.set_shader_parameter("progress", 1)
			if (changingScene):
				get_tree().change_scene_to_file(sceneToLoad)
			else:
				fadingIn = false
				player._set_freeze(false)
		else:
			material.set_shader_parameter("progress", shaderProgress)

# Start the attached scene change shader & save new scene / player position
func _change_scene(newScene, newPos) -> void:
	saveNode.save_OW(newPos, newScene)
	changingScene = true
	material.set_shader_parameter("fadeOut", true)
	material.set_shader_parameter("progress", 0)
	shaderProgress = 0
	player._set_freeze(true)
	sceneToLoad = scenePath + newScene + ".tscn"


func _on_door_change_scene(newScene: Variant, newPos: Variant) -> void:
	pass # Replace with function body.
