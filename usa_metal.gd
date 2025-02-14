extends Node3D
var state = true
var timer=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func action():
	if state and timer:
		$AnimationPlayer.play("open")
		state=false
		print(1)
		timer=false
		$Timer.start()
	if not state and timer:
		$AnimationPlayer.play("close")
		state=true
		print(2)
		timer=false
		$Timer.start()


func _on_timer_timeout() -> void:
	timer=true
