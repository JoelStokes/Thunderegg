extends CharacterBody3D

#Isometric movement values. North (pressing "up") is diagonally up-right
const NORTH = Vector2(12,-6)
const SOUTH = Vector2(-12,6)
const EAST = Vector2(12,6)
const WEST = Vector2(-12,-6)
const NORTHEAST = Vector2(13,0)
const NORTHWEST = Vector2(0,-13)
const SOUTHEAST = Vector2(0,13)
const SOUTHWEST = Vector2(-13,0)
const SPEED = 3
var buffer = .3	#Used for stick angle & analog movement checks

#Text, Interactables, & Cutscene variables
var frozen = false
var question = false
var questionAlpha = 200
@onready var questionNode = get_node("Question")

#Player movement graphics
var lastAnim = ""
@onready var animator = get_node("Sprite3D/PlayerAnimation")
var stoppedMoving = false	#Helps animation restart again on same direction move

#Ground checks for movement to prevent falling off map
var raycastMove = .25
var rayX = 0
var rayZ = 0
@onready var raycast = get_node("RayCast3D")

func _physics_process(_delta: float) -> void:
	#Handle player movement
	#Once save data, add toggle that lets user set control preference between 2 styles?
	
	#Traditional movement - Up is straight up, diagonals follow iso grid
	if (!frozen):
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

		#Velocity checks to ensure stick is outside of deadzone
		var velocityX = 0
		var velocityZ = 0
		if (direction.x < -buffer || direction.x > buffer):
			velocityX = (direction.x * SPEED)
		if (direction.y < -buffer || direction.y > buffer):
			velocityZ = (direction.y * SPEED)

		self.velocity = Vector3(velocityX, self.velocity.y, velocityZ)
		if not is_on_floor():
			self.velocity += get_gravity() * _delta
		
		if (direction.x < -buffer && direction.y < -buffer):		#UpLeft / NW
			_set_move("NW", -raycastMove, -raycastMove)
		elif (direction.x < -buffer && direction.y > buffer):		#DownLeft / SW
			_set_move("SW", -raycastMove, raycastMove)
		elif (direction.x > buffer && direction.y < -buffer):		#UpRight / NE
			_set_move("NE", raycastMove, -raycastMove)
		elif (direction.x > buffer && direction.y > buffer):		#DownRight / SE
			_set_move("SE", raycastMove, raycastMove)
		elif (direction.x < -buffer):		#Left / W
			_set_move("W", -raycastMove, 0)
		elif (direction.x > buffer):	#Right / E
			_set_move("E", raycastMove, 0)
		elif (direction.y > buffer):	#Down / S
			_set_move("S", 0, raycastMove)	
		elif (direction.y < -buffer):	#Up / N
			_set_move("N", 0, -raycastMove)
		else:
			_stop_anim()
	
		# Check Raycast in direction player is moving. If Raycast is not null, let the player move
		raycast.position = Vector3(rayX, raycast.position.y, rayZ)
		if (raycast.get_collider()):
			move_and_slide()

func _set_freeze(state) -> void:
	frozen = state
	_stop_anim()
	
func _toggle_question(state) -> void:
	if (state):
		questionNode.modulate = Color(1,1,1,questionAlpha)
	else:
		questionNode.modulate = Color(1,1,1,0)

# Set animation & update moving direction's next raycast to check
func _set_move(dir, x, z) -> void:
	var newAnim = "walk_" + dir
	if (lastAnim != newAnim || stoppedMoving):
		animator.play(newAnim)
		lastAnim = newAnim
		stoppedMoving = false
	rayX = x
	rayZ = z

func _stop_anim() -> void:
	# Don't do in cases where animator hasn't loaded yet (ex. freeze on scene load)
	if (animator):
		animator.stop()
		animator.seek(0, true)
		stoppedMoving = true
