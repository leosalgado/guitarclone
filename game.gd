extends Node3D

@onready var music_node = $Music
@onready var road_node = $Road

var audio
var map
var audio_file = "res://audio.ogg"
var map_file = "res://map.mboy"

var tempo
var bar_length_in_m
var quarter_time_in_sec
var speed
var note_scale
var start_pos_in_sec

func _ready():
	audio = load(audio_file)
	map = load_map()
	calc_params()
	
	music_node.setup(self)
	road_node.setup(self)
	
func calc_params():
	tempo = int(map.tempo)
	bar_length_in_m = 16 # Godot meters
	quarter_time_in_sec = 60/float(tempo) # 60/60 = 1, 60/85 = 0.71
	speed = bar_length_in_m/float(4*quarter_time_in_sec) # each bar has 4 quarters # 
	note_scale = bar_length_in_m/float(4*400)
	start_pos_in_sec = (float(map.start_pos)/400.0) * quarter_time_in_sec
	
#func load_map():
	#var file = File.new()
	#file.open(map_file, File.READ)
	#var content = file.get_as_text()
	#file.close()
	#var test_json_conv = JSON.new()
	#test_json_conv.parse(content).get_data()
	#return test_json_conv.get_data()
	#
func load_map():
	var file = FileAccess.open(map_file, FileAccess.READ)
	if file == null:
		push_error("Erro ao abrir o arquivo do mapa.")
		return {}
	var content = file.get_as_text()
	file.close()
	var test_json_conv = JSON.new()
	var err = test_json_conv.parse(content)
	if err != OK:
		push_error("Erro ao fazer parse do JSON.")
		return {}
	return test_json_conv.get_data()
