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
var northSprite = preload("res://Sprites/Objects/PlayerNorth.png")
var southSprite = preload("res://Sprites/Objects/PlayerSouth.png")
var northeastSprite = preload("res://Sprites/Objects/PlayerNortheast.png") #Flipped for SW
var northwestSprite = preload("res://Sprites/Objects/PlayerNorthwest.png")
var southeastSprite = preload("res://Sprites/Objects/PlayerSoutheast.png")
@onready var sprite3D = get_node("Sprite3D")

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
		
		if (direction.x < -buffer && direction.y < -buffer):		#UpLeft / W
			_set_move(northSprite, true, -raycastMove, -raycastMove)
		elif (direction.x < -buffer && direction.y > buffer):		#DownLeft / S
			_set_move(southSprite, false, -raycastMove, raycastMove)
		elif (direction.x > buffer && direction.y < -buffer):		#UpRight / N
			_set_move(northSprite, false, raycastMove, -raycastMove)
		elif (direction.x > buffer && direction.y > buffer):		#DownRight / E
			_set_move(southSprite, true, raycastMove, raycastMove)
		elif (direction.x < -buffer):		#Left / SW
			_set_move(northeastSprite, true, -raycastMove, 0)
		elif (direction.x > buffer):	#Right / NE
			_set_move(northeastSprite, false, raycastMove, 0)
		elif (direction.y > buffer):	#Down / SE
			_set_move(southeastSprite, false, 0, raycastMove)	
		elif (direction.y < -buffer):	#Up / NW
			_set_move(northwestSprite, false, 0, -raycastMove)
		
		# Check Raycast in direction player is moving. If Raycast is not null, let the player move
		raycast.position = Vector3(rayX, raycast.position.y, rayZ)
		if (raycast.get_collider()):
			move_and_slide()

func _set_freeze(state) -> void:
	frozen = state
	
func _toggle_question(state) -> void:
	if (state):
		questionNode.modulate = Color(1,1,1,questionAlpha)
	else:
		questionNode.modulate = Color(1,1,1,0)

# Apply sprite, flip sprite if applicable, update moving direction's next raycast to check
func _set_move(sprite, flip, x, z) -> void:
	sprite3D.texture = sprite
	sprite3D.flip_h = flip
	rayX = x
	rayZ = z
