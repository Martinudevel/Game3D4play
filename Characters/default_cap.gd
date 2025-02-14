extends CharacterBody3D
@onready var raycast =$RayCast3D
var direction: Vector3 = Vector3.ZERO

# Camera settings
@export var mouse_sensitivity: float = 0.1
@export var camera_pitch_limit: float = 90.0
@export var camera_yaw_limit: float = 90.0
# Camera nodes

@onready var camera: Camera3D = $cam/Camera3D
var Pause=false
# Movement settings
@export var speed: float = 5.0
@export var jump_force: float = 10.0
@export var gravity: float = 20.0
@export var max_fall_speed: float = 50.0
var run=false

var new=true
# Internal variables
var yaw: float = 0.0
var pitch: float = 0.0
func _ready():
	# Capture the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.transform.origin=Vector3(0,60.006,0)
	self.scale=Vector3(10,10,10)

func _input(event):
	# Handle mouse movement for camera rotation
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		
		# Clamp the pitch to avoid flipping the camera
		pitch= clamp(pitch, -camera_pitch_limit, camera_pitch_limit)
		
		# Apply rotation to the camera and player
		
		self.rotation_degrees.y = yaw
		camera.rotation_degrees.x = pitch
		

func _process(delta):
 # Reset direction
	direction = Vector3.ZERO

	# Get input for movement
	if Input.is_action_pressed("ui_shift"):
		speed=60
		run=true
	else :
		speed=30
		run=false
	if Input.is_action_pressed("ui_up"):
		direction += transform.basis.z
		if run:
			$AnimationPlayer.play("Animation_library/run")
		else :
			$AnimationPlayer.play("Animation_library/walk")
	if Input.is_action_pressed("ui_down"):
		direction -= transform.basis.z
		if run:
			$AnimationPlayer.play("Animation_library/run")
		else :
			$AnimationPlayer.play("Animation_library/walk")
	if Input.is_action_pressed("ui_left"):
		direction += transform.basis.x
		if run:
			$AnimationPlayer.play("Animation_library/run")
		else :
			$AnimationPlayer.play("Animation_library/walk")
	if Input.is_action_pressed("ui_right"):
		direction -= transform.basis.x
		if run:
			$AnimationPlayer.play("Animation_library/run")
		else :
			$AnimationPlayer.play("Animation_library/walk")
	if velocity==Vector3.ZERO:
		$AnimationPlayer.play("IDLE_Anim/Armature|mixamo_com|Layer0")
	# Normalize direction to prevent faster diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()

	# Apply movement
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Apply gravity
	if not is_on_floor() and not new:
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		if run:
			$AnimationPlayer.play("Animation_library/jump-Run")
		else:
			$AnimationPlayer.play("Animation_library/jump")

	# Move the player using KinematicBody's move_and_slide function
	move_and_slide()
	
	if Input.is_action_just_pressed("e"):
		if raycast.get_collider():
			raycast.get_collider().interact()
		$AnimationPlayer.play("Animation_library/button push")
		


func _unhandled_input(event):
	# Allow the player to exit mouse capture
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if Pause:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			if not Pause:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$"Pause Menu".visible=not $"Pause Menu".visible
			Pause=not Pause


func _on_timer_timeout() -> void:
	new=false
