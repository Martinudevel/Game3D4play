extends Node3D
@onready var Player= $"../../spawner"
@export var Cap_default=preload("res://Characters/Default Cap.tscn").instantiate()
@export var type="Cap"
@export var Hero_default=preload("res://hero_default.tscn").instantiate()
@export var Deco_default=preload("res://deco_default.tscn").instantiate()
@export var Plan_default=preload("res://plan_default.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func interact(name_play):
	if type=="Cap":
		var NewPlayer=Player.get_children(name_play)
		for n in NewPlayer.get_children():
			Player.remove_child(n)
			n.queue_free() 
		Player.add_child(Cap_default)
	if type=="Deco":
		var NewPlayer=Player.get_children(name_play)
		for n in NewPlayer.get_children():
			Player.remove_child(n)
			n.queue_free()
		Player.add_child(Deco_default)
	if type=="Plan":
		var NewPlayer=Player.get_children(name_play)
		for n in NewPlayer.get_children():
			Player.remove_child(n)
			n.queue_free()
		Player.add_child(Plan_default)
	if type=="Hero":
		var NewPlayer=Player.get_children(name_play)
		for n in NewPlayer.get_children():
			Player.remove_child(n)
			n.queue_free()
		Player.add_child(Hero_default)
	
