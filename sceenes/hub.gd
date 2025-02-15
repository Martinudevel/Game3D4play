extends Node3D


@onready var Main_menu=$CanvasLayer/PanelContainer
@onready var PORT = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/port
var peer= ENetMultiplayerPeer.new()

@onready var ip_input = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/ip
@export var player_sceene : PackedScene

func _on_host_button_pressed():
	Main_menu.hide()
	peer.create_server(int(PORT.text))
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	print(peer)
	print("✅ Server started as player ", multiplayer.get_unique_id())
	add_player(multiplayer.get_unique_id())
	
func _on_peer_connected(id):
	print("New player joined with ID:", id)
func add_player(peer_id):
	var player=player_sceene.instantiate()
	player.name=str(peer_id)
	$spawner.add_child(player)
	print(4)
	print("Player", peer_id, "spawned with authority:", player.get_multiplayer_authority())
	
@rpc("any_peer", "call_local")
func request_spawn():
	if multiplayer.is_server():
		var new_player_id = multiplayer.get_remote_sender_id()
		add_player(new_player_id)  # Assigns only to the new player
	
func _on_join_button_pressed():
	Main_menu.hide()
	peer.create_client(ip_input.text, int(PORT.text))
	multiplayer.multiplayer_peer = peer
	print(peer)
	print("✅ Connected as player ", multiplayer.get_unique_id())


func exit_game(id):
		multiplayer.peer_disconnected.connect(_on_player_disconnected)
		delete_play(id)

func _on_player_disconnected(id):
	print("❌ Player left:", id)
	$"../spawner".delete_play(id)
func delete_play(id):
	rpc("_delete_play",id)
@rpc("any_peer","call_local")
func _delete_play(id):
	$"../spawner".get_node(str(id)).queue_free()
	
