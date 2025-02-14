extends Node3D
@onready var spawner=$spawner
@onready var player=preload("res://player.tscn").instantiate()

@rpc("any_peer")
func add_player(player_id):
	print("🎮 Adding player:", player_id)
	var player = preload("res://Player.tscn").instantiate()
	player.name = str(player_id)  # Name it by player ID
	spawner.add_child(player)
func  remove_player(id):
	if spawner.has_node(str(id)):
		spawner.get_node(str(id)).queue_free()  # Remove player
