extends Node3D

var green_mat = preload("res://note/green_beam_mat.tres")
var red_mat = preload("res://note/red_beam_mat.tres")
var yellow_mat = preload("res://note/yellow_beam_mat.tres")
	
func set_material(line):
	match line:
		1:
			$MeshInstance3D.material_override = green_mat
		2:
			$MeshInstance3D.material_override = red_mat
		3:
			$MeshInstance3D.material_override = yellow_mat
