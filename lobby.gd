extends Control

@onready var ip_input = $IPInput

var peer = ENetMultiplayerPeer.new()

func _on_HostButton_pressed():
	peer.create_server(12345)  # Use any port number
	multiplayer.multiplayer_peer = peer
	multiplayer.connect("peer_connected", _on_peer_connected)
	get_tree().change_scene_to_file("res://game.tscn")

func _on_JoinButton_pressed():
	var ip = ip_input.text
	if ip == "":
		ip = "127.0.0.1"  # Default to localhost
	peer.create_client(ip, 12345)
	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://game.tscn")

func _on_peer_connected(id):
	print("Player connected: ", id)
