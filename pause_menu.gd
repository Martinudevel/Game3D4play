extends Control
@onready var Player=$"../"



func _on_resume_pressed() -> void:
	self.visible=false
	Player.Pause=false

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://settings.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://control.tscn")
