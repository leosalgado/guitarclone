extends Node3D

var green_mat = preload("res://green_mat.tres")
var red_mat = preload("res://red_mat.tres")
var yellow_mat = preload("res://yellow_mat.tres")

@export var line: int = 1

var is_pressed = false

func _ready():
	set_material()
	set_process_input(true)

func set_material():
	match line:
		1:
			$MeshInstance3D.material_override = green_mat
		2:
			$MeshInstance3D.material_override = red_mat
		3:
			$MeshInstance3D.material_override = yellow_mat

func _input(event):
	match line:
		1:
			if event.is_action_pressed("ui_down"):
				is_pressed = true
			elif event.is_action_released("ui_down"):
				is_pressed = false
		2:
			if event.is_action_pressed("ui_left"):
				is_pressed = true
			elif event.is_action_released("ui_left"):
				is_pressed = false
		3:
			if event.is_action_pressed("ui_right"):
				is_pressed = true
			elif event.is_action_released("ui_right"):
				is_pressed = false

func _process(delta):
	if is_pressed:
		self.scale = Vector3(0.9, 0.9, 0.9)
	else:
		self.scale = Vector3(1,1,1)
