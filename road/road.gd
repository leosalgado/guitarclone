extends Node3D

var bar_scn = preload("res://bar.tscn")
var bars = []
@onready var bars_node = $BarsNode

var bar_length_in_m
var curr_location
var speed
var note_scale
var surface_speed

var curr_bar_index
var tracks_data 
var started

func setup(game):
	started = false
	speed = Vector3(0,0,game.speed)
	bar_length_in_m = game.bar_length_in_m
	curr_location = Vector3(0,0,-bar_length_in_m)
	note_scale = game.note_scale
	curr_bar_index = 0
	tracks_data = game.map.tracks
	surface_speed = Vector3(-game.quarter_time_in_sec, 0, 0)
	add_bars()
	#apply_surface_speed()
	
		
func _process(delta):
	if not started:
		return
	
	bars_node.translate(speed*delta)
	
	for bar in bars:
		if bar.position.z + bars_node.position.z >= bar_length_in_m:
			remove_bar(bar)
			add_bar()
		
func start():
	started = true

func add_bar():	
	var bar = bar_scn.instantiate()
	bar.position = Vector3(curr_location.x, curr_location.y, curr_location.z)
	bar.note_scale = note_scale
	bar.bar_data = get_bar_data()
	bar.speed = speed
	bars.append(bar)
	bars_node.add_child(bar)
	curr_location += Vector3(0,0,-bar_length_in_m)
	curr_bar_index += 1
	
func get_bar_data():
	var left_data = tracks_data[0].bars[curr_bar_index]
	var center_data = tracks_data[1].bars[curr_bar_index]
	var right_data = tracks_data[2].bars[curr_bar_index]
	return [left_data, center_data, right_data]
	
func remove_bar(bar):
	bar.queue_free()
	bars.erase(bar)
	
func add_bars():
	for i in range(4):
		add_bar()
	
#func apply_surface_speed():
	#var mat = $RoadSurface/Plane.get_surface_override_material(0)
	#mat.set_shader_parameter("Speed", surface_speed)
