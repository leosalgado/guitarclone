extends Node3D

@onready var player = $AudioStreamPlayer
@onready var anim = $AnimationPlayer

var speed
var started
var pre_start_duration
var start_pos_in_sec

func _ready():
	pass
	
func setup(game):
	player.stream = game.audio
	
	speed = game.speed
	started = false
	pre_start_duration = game.bar_length_in_m
	start_pos_in_sec = game.start_pos_in_sec
	
func start():
	started = true
	await get_tree().create_timer(2.5).timeout
	player.play(start_pos_in_sec)
	anim.play("sound_on")
	
func _process(delta):
	if not started:
		#pre_start_duration -= speed*delta
		#if pre_start_duration <= 0:
			#start()
		return
