extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().add_child(preload("res://Characters/Default Cap.tscn").instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
