extends Node3D

var green_mat = preload("res://note/green_note_mat.tres")
var red_mat = preload("res://note/red_note_mat.tres")
var yellow_mat = preload("res://note/yellow_note_mat.tres")

@export var line: int = 1
var note_position = 0
var length
var length_scale
var speed

var is_colliding = false
var collected = false
var picker

@onready var cover = $NoteMesh/NoteCover

func _ready():
	_on_ready()
	
func _on_ready():
	set_material()
	set_note_position()
	add_listeners()
	
func _process(delta):
	_on_process(delta)
	
func _on_process(delta):
	pass
	
func set_material():
	match line:
		1:
			cover.material_override = green_mat
		2:
			cover.material_override = red_mat
		3:
			cover.material_override = yellow_mat
			
func set_note_position():
	var x 
	match line:
		1:
			x = -1
		2:
			x = 0
		3:
			x = 1
	self.position = Vector3(x,0,-note_position*length_scale)
	
func add_listeners():
	$Area3D.add_to_group("note")
	$Area3D.connect("area_entered", Callable(self, "_on_area_entered"))
	$Area3D.connect("area_exited", Callable(self, "_on_area_exited"))
	
	
func collect():
	collected = true
	picker.on_collect()
	Score.add_points(10)
	hide()

func _on_area_entered(area):
	if area.is_in_group("picker"):
		is_colliding = true
		picker = area.get_parent()
		

func _on_area_exited(area):
	if area.is_in_group("picker"):
		is_colliding = false
