extends Node

var client := StreamPeerTCP.new()
var connected = false
var ready_sent = false
var game_started = false

var client_id := ""

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
			client.put_data("ready\n".to_utf8_buffer())
			ready_sent = true
			print("Sinal de ready enviado.")

@export var broadcast_interval := 0.5 
var broadcast_timer := 0.0

func _process(delta):
	if connected:
		client.poll()  # MUITO IMPORTANTE para processar envio/recebimento

		if client.get_available_bytes() > 0:
			var msg = client.get_utf8_string(client.get_available_bytes()).strip_edges()
			if msg == "start" and not game_started:
				game.game_start()
				#game_started = true
			elif ":" in msg and client_id == "":
				client_id = msg
				print("client_id:", client_id)
		
		
		broadcast_timer += delta
		if broadcast_timer >= broadcast_interval:
			broadcast_timer = 0.0
			broadcast_score_to_clients()

func broadcast_score_to_clients():
	var score = Score.points  # Score.gd é singleton, pode acessar direto
	print(score)
	client.put_data((client_id + "," + str(score)).to_utf8_buffer())
