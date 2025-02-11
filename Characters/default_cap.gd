extends CharacterBody3D
@onready var raycast =$RayCast3D

# Camera settings
@export var mouse_sensitivity: float = 0.1
@export var camera_pitch_limit: float = 90.0
@export var camera_yaw_limit: float = 90.0
# Camera nodes
@onready var head: Node3D= $Armature/Skeleton3D/Body/cam
@onready var camera: Camera3D = $Armature/Skeleton3D/Body/cam/Camera3D

# Movement settings
@export var speed: float = 5.0
@export var jump_force: float = 10.0
@export var gravity: float = 20.0
@export var max_fall_speed: float = 50.0

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
	if not raycast.is_colliding():
		print(1)
		velocity.y -= gravity * delta
		# Clamp fall speed to prevent excessive bouncing
		if velocity.y < -max_fall_speed:
			velocity.y = -max_fall_speed
			
		else:
		# Reset vertical velocity when grounded
			velocity.y = 0
			
			
			

	# Handle jumpings
	if Input.is_action_just_pressed("ui_accept") and raycast.is_colliding():
		velocity.z = jump_force
		print(2)

	# Get input for movement	
	var direction: Vector3 = Vector3.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")

	# Normalize direction to prevent faster diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()

	# Apply movement
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed

	# Move the character
	var collision = move_and_collide(velocity * delta)

	# Handle collisions
	if collision:
		# Slide along the surface of the collision
		var slide_velocity = velocity.slide(collision.get_normal())
		velocity = slide_velocity
	# Optional: Reset horizontal velocity when no input
	if direction.length() == 0:
		velocity.x = 0
		velocity.y = 0
		

func _unhandled_input(event):
	# Allow the player to exit mouse capture
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
