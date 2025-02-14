extends Area3D
@onready var capsula=$"../"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func interact(name_play):
	
	capsula.interact(name_play)
