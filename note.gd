extends Node3D

var green_mat = preload("res://green_mat.tres")
var red_mat = preload("res://red_mat.tres")
var yellow_mat = preload("res://yellow_mat.tres")

@export var line: int = 1

var is_pressed = false

func _ready():
	set_material()

func set_material():
	match line:
		1:
			$MeshInstance3D.material_override = red_mat
		2:
			$MeshInstance3D.material_override = green_mat
		3:
			$MeshInstance3D.material_override = yellow_mat
