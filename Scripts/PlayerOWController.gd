extends CharacterBody2D

#Isometric movement values. North (pressing "up") is diagonally up-right
const NORTH = Vector2(12,-6)
const SOUTH = Vector2(-12,6)
const EAST = Vector2(12,6)
const WEST = Vector2(-12,-6)
const NORTHEAST = Vector2(13,0)
const NORTHWEST = Vector2(0,-13)
const SOUTHEAST = Vector2(0,13)
const SOUTHWEST = Vector2(-13,0)
const SPEED = 11
var buffer = .3	#Used for stick angle & analog movement checks

#Player movement graphics
var northSprite = preload("res://Sprites/Objects/PlayerNorth.png")
var southSprite = preload("res://Sprites/Objects/PlayerSouth.png")
var northeastSprite = preload("res://Sprites/Objects/PlayerNortheast.png") #Flipped for SW
var northwestSprite = preload("res://Sprites/Objects/PlayerNorthwest.png")
var southeastSprite = preload("res://Sprites/Objects/PlayerSoutheast.png")
@onready var sprite2D = get_node("Sprite2D")

func _physics_process(_delta: float) -> void:
	#Handle player movement
	#Once save data, add toggle that lets user set control preference between 2 styles?
	
	#Traditional movement - Up is straight up, diagonals follow iso grid
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if (direction.x < -buffer && direction.y < -buffer):		#UpLeft / W
		sprite2D.texture = northSprite
		sprite2D.flip_h = true
		self.velocity = WEST * SPEED
	elif (direction.x < -buffer && direction.y > buffer):		#DownLeft / S
		sprite2D.texture = southSprite
		sprite2D.flip_h = false
		self.velocity = SOUTH * SPEED
	elif (direction.x > buffer && direction.y < -buffer):		#UpRight / N
		sprite2D.texture = northSprite
		sprite2D.flip_h = false
		self.velocity = NORTH * SPEED
	elif (direction.x > buffer && direction.y > buffer):		#DownRight / E
		sprite2D.texture = southSprite
		sprite2D.flip_h = true
		self.velocity = EAST * SPEED
	elif (direction.x < -buffer):		#Left / SW
		sprite2D.texture = northeastSprite
		sprite2D.flip_h = true
		self.velocity = SOUTHWEST * SPEED
	elif (direction.x > buffer):	#Right / NE
		sprite2D.texture = northeastSprite
		sprite2D.flip_h = false
		self.velocity = NORTHEAST * SPEED
	elif (direction.y > buffer):	#Down / SE
		sprite2D.texture = southeastSprite
		sprite2D.flip_h = false
		self.velocity = SOUTHEAST * SPEED
	elif (direction.y < -buffer):	#Up / NW
		sprite2D.texture = northwestSprite
		sprite2D.flip_h = false
		self.velocity = NORTHWEST * SPEED
	elif (!direction || direction == Vector2.ZERO):
		self.velocity = Vector2.ZERO
	
	''' Iso movement - Up is North (default to diagonal grid movement, diagonal inputs are straight)
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if (direction.x < -buffer && direction.y < -buffer):		#UpLeft / NW
		sprite2D.texture = northwestSprite
		sprite2D.flip_h = false
		self.velocity = NORTHWEST * SPEED
	elif (direction.x < -buffer && direction.y > buffer):		#DownLeft / SW
		sprite2D.texture = northeastSprite
		sprite2D.flip_h = true
		self.velocity = SOUTHWEST * SPEED
	elif (direction.x > buffer && direction.y < -buffer):		#UpRight / NE
		sprite2D.texture = northeastSprite
		sprite2D.flip_h = false
		self.velocity = NORTHEAST * SPEED
	elif (direction.x > buffer && direction.y > buffer):		#DownRight / SE
		sprite2D.texture = southeastSprite
		sprite2D.flip_h = false
		self.velocity = SOUTHEAST * SPEED
	elif (direction.x < -buffer):		#Left
		sprite2D.texture = northSprite
		sprite2D.flip_h = true
		self.velocity = WEST * SPEED
	elif (direction.x > buffer):	#Right
		sprite2D.texture = southSprite
		sprite2D.flip_h = true
		self.velocity = EAST * SPEED
	elif (direction.y < -buffer):	#Down
		sprite2D.texture = northSprite
		sprite2D.flip_h = false
		self.velocity = NORTH * SPEED
	elif (direction.y > buffer):	#Up
		sprite2D.texture = southSprite
		sprite2D.flip_h = false
		self.velocity = SOUTH * SPEED
	elif (!direction || direction == Vector2.ZERO):
		self.velocity = Vector2.ZERO
	'''
	
	move_and_slide()
