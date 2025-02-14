extends Node3D
@export var player_id: int = 1  # Set this when spawning

	# Capture the mouse
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if multiplayer.get_unique_id() != player_id:
		$untitled/cam/Camera3D.current = false  # Disable camera for other players
	else:
		$untitled/cam/Camera3D.current = true  # Enable camera for self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
