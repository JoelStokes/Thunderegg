extends Area2D

signal setPosition
signal bodyStatus

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setPosition.emit(self.name, self.position)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body):
	if (body.name == "PlayerOW"):
		bodyStatus.emit(self.name, true, body)

func _on_body_exited(body):
	if (body.name == "PlayerOW"):
		bodyStatus.emit(self.name, false, body)
