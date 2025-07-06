class_name Pokemon	#Structure for a specific Pokemon. Uses data based on pokemon.json as a template
extends Resource

@export var id := 0		#Corresponding json pokemon list value
@export var nickname := ""

@export var level := 0
@export var experience := 0
@export var totalHealth := 0
@export var currentHealth := 0

#@export Resource Move[]
# Handle what moves are learned, how much PP they have, and max PP

# Handle specific stats & changes, along with friendship etc.
