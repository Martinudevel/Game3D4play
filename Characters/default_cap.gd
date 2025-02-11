extends CharacterBody3D

# Camera settings
@export var mouse_sensitivity: float = 0.1
@export var camera_pitch_limit: float = 90.0
@export var camera_yaw_limit: float = 90.0
# Camera nodes
@onready var head: Node3D= $Armature/Skeleton3D/Body/cam
@onready var camera: Camera3D = $Armature/Skeleton3D/Body/cam/Camera3D

# Movement settings
@export var speed: float = 5.0
@export var jump_velocity: float = 5.0
@export var gravity: float = 9.8
var input_direction = Vector3.ZERO
# Internal variables
var yaw: float = 0.0
var pitch: float = 0.0
func _ready():
	# Capture the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Handle mouse movement for camera rotation
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		
		# Clamp the pitch to avoid flipping the camera
		pitch= clamp(pitch, -camera_pitch_limit, camera_pitch_limit)
		
		# Apply rotation to the camera and player
		head.rotation_degrees.y = yaw
		camera.rotation_degrees.x = pitch
		

func _process(delta):
	
	# Handle movement
	
	
	print(transform.origin)

	if Input.is_action_pressed("move_forward"):
		input_direction += transform.basis.y
		print(input_direction)
	if Input.is_action_pressed("move_backward"):
		input_direction -= transform.basis.y
		print(input_direction)
	if Input.is_action_pressed("move_left"):
		input_direction += transform.basis.x
		print(input_direction)
	if Input.is_action_pressed("move_right"):
		input_direction -= transform.basis.x
		print(input_direction)
	else:
		input_direction = Vector3.ZERO

	# Normalize input direction to prevent faster diagonal movement
	input_direction = input_direction.normalized()
	print(input_direction)

	# Apply movement
	velocity.x = input_direction.x * speed
	velocity.y = input_direction.y * speed

	# Apply gravity
	if not is_on_floor():
		velocity.z -= gravity * delta
	else:
		velocity.z = 0.0

		# Handle jumping
		if Input.is_action_just_pressed("jump"):
			velocity.z = jump_velocity

	# Move the player
	move_and_slide()

func _unhandled_input(event):
	# Allow the player to exit mouse capture
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
