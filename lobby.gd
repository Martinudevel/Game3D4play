extends Control

const PORT = 7777
var peer: ENetMultiplayerPeer
@onready var map=preload("res://sceenes/hub.tscn").instantiate()

@onready var ip_input = $IPInput
@onready var player_container = $PlayerContainer  # Node to hold player instances

func _on_host_button_pressed():

	force_reset_multiplayer()
	start_server()
	map.add_player(multiplayer.get_unique_id())  # Add host as a player

func _on_join_button_pressed():

	var ip_address = ip_input.text
	force_reset_multiplayer()
	connect_to_server(ip_address)

func force_reset_multiplayer():
	print("🔄 FORCING MULTIPLAYER RESET...")
	
	if multiplayer.multiplayer_peer:
		print("🔌 Closing existing connection...")
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null  # Remove peer reference
	
	await get_tree().process_frame  
	
	peer = ENetMultiplayerPeer.new()
	print("✅ Multiplayer peer fully reset.")

func start_server():
	peer = ENetMultiplayerPeer.new()
	print("🚀 Starting server...")
	var error = peer.create_server(PORT, 8)
	if error != OK:
		print("❌ Failed to start server:", error)
		return
	
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	
	print("✅ Server started as player", multiplayer.get_unique_id())

func connect_to_server(ip_address):
	peer = ENetMultiplayerPeer.new()
	print("🌐 Attempting to connect to:", ip_address)
	var error = peer.create_client(ip_address, PORT)
	if error != OK:
		print("❌ Failed to connect:", error)
		return

	multiplayer.multiplayer_peer = peer
	print("✅ Connected as player", multiplayer.get_unique_id())


func _on_player_connected(id):
	print("🎉 Player joined:", id)
	map.add_player.rpc(id)  # Sync the new player across all clients

func _on_player_disconnected(id):
	print("❌ Player left:", id)
	map.remove_player(id)
