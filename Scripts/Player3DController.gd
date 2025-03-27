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

#Text & Cutscene variables
var frozen = false

#Player movement graphics
var northSprite = preload("res://Sprites/Objects/PlayerNorth.png")
var southSprite = preload("res://Sprites/Objects/PlayerSouth.png")
var northeastSprite = preload("res://Sprites/Objects/PlayerNortheast.png") #Flipped for SW
var northwestSprite = preload("res://Sprites/Objects/PlayerNorthwest.png")
var southeastSprite = preload("res://Sprites/Objects/PlayerSoutheast.png")
@onready var sprite3D = get_node("Sprite3D")

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
			sprite3D.texture = northSprite
			sprite3D.flip_h = true
		elif (direction.x < -buffer && direction.y > buffer):		#DownLeft / S
			sprite3D.texture = southSprite
			sprite3D.flip_h = false
		elif (direction.x > buffer && direction.y < -buffer):		#UpRight / N
			sprite3D.texture = northSprite
			sprite3D.flip_h = false
		elif (direction.x > buffer && direction.y > buffer):		#DownRight / E
			sprite3D.texture = southSprite
			sprite3D.flip_h = true
		elif (direction.x < -buffer):		#Left / SW
			sprite3D.texture = northeastSprite
			sprite3D.flip_h = true
		elif (direction.x > buffer):	#Right / NE
			sprite3D.texture = northeastSprite
			sprite3D.flip_h = false
		elif (direction.y > buffer):	#Down / SE
			sprite3D.texture = southeastSprite
			sprite3D.flip_h = false
		elif (direction.y < -buffer):	#Up / NW
			sprite3D.texture = northwestSprite
			sprite3D.flip_h = false
		
		move_and_slide()

func _set_freeze(state) -> void:
	frozen = state
