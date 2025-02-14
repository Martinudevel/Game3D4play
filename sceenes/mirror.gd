extends MeshInstance3D

@onready var dummy_cam = $dummy_cam
@onready var mirror_cam = $SubViewport/Camera3D
 
func _ready():
	add_to_group("mirrors")
	#$SubViewport.size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
 
func update_cam(main_cam_transform):
	scale.y *= -1
	dummy_cam.global_transform = main_cam_transform
	scale.y *= -1
	mirror_cam.global_transform = dummy_cam.global_transform
	mirror_cam.global_transform.basis.x *= -1
