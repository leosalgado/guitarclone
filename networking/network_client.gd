extends Node

var client := StreamPeerTCP.new()
var connected = false
var ready_sent = false
var game_started = false

@onready var game = get_parent()

func _ready():
	connect_to_server()

func connect_to_server():
	var err = client.connect_to_host("127.0.0.1", 9000)
	if err == OK:
		print("Conectado ao servidor.")
		connected = true
	else:
		print("Erro ao conectar.")

func _input(event):
	if connected and not ready_sent and event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			client.put_utf8_string("ready\n")
			ready_sent = true
			print("Sinal de ready enviado.")

#func _process(delta):
	#if connected and client.get_available_bytes() > 0:
		#var msg = client.get_utf8_string(client.get_available_bytes()).strip_edges()
		#if msg == "start" and not game_started:
			#game.start_game()
			#game_started = true

func _process(delta):
	if not connected:
		if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
			print("Conexão estabelecida com sucesso.")
			connected = true
		else:
			return  # ainda não conectado

	client.poll()  # MUITO IMPORTANTE para processar envio/recebimento

	if client.get_available_bytes() > 0:
		var msg = client.get_utf8_string(client.get_available_bytes()).strip_edges()
		if msg == "start" and not game_started:
			game.game_start()
			#game_started = true
