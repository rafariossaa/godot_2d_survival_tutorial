extends Node2D

const MAX_RADIOUS = 100
const MAX_ROTATIONS = 2.0
const DURATION = 3 # seconds

@onready var hitbox_component = $HitboxComponent

var base_rotation = Vector2.RIGHT

func _ready():
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var tween = create_tween()
	# tween.tween_method is going to call tween_metod over 3 secons with values from 0.0 to 2.0
	tween.tween_method(tween_method, 0.0, MAX_ROTATIONS, DURATION)
	tween.tween_callback(queue_free)

# Animate axe moven in sprial 
func tween_method(rotations: float):
	var percent = (rotations / MAX_ROTATIONS)
	var current_radius = percent * MAX_RADIOUS
	var current_direction = base_rotation.rotated(rotations * TAU)

	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	global_position = player.global_position + (current_direction * current_radius)
