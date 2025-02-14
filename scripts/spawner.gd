extends Node3D

@onready var player_scene = preload("res://Characters/default_cap.gd")

func _ready():
	if multiplayer.is_server():
		spawn_players()

func spawn_players():
	for peer_id in multiplayer.get_peers():
		var player = player_scene.instantiate()
		player.name = str(peer_id)
		player.set_multiplayer_authority(peer_id)
		add_child(player)
