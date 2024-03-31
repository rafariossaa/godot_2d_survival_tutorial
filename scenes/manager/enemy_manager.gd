extends Node

const SPAWN_RADIUS = 375

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene

@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()


func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	
	timer.timeout.connect(on_timer_timeout)
	base_spawn_time = timer.wait_time
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)

func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return Vector2.ZERO
	
	#Try 4 different directions (90 deg) where to spawn the enemy
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)

		#Ray cast check to check if there is a wall (layer_0 = 1) between the player position and the spawn position
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)

		# we are clear
		if result.is_empty():
			break
		else:
			# If there is a wall then rotate 90 degs
			random_direction = random_direction.rotated(deg_to_rad(90))

	return spawn_position


func on_timer_timeout():
	# This will apply the next timeout setting
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D

	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (.1 / 12) * arena_difficulty
	#Clamp to a limit
	time_off = min(time_off, .7)
	print("Time: " + str(base_spawn_time - time_off) )
	timer.wait_time = base_spawn_time - time_off
	
	# at 30 secods we add the wizard
	if arena_difficulty == 6:
		enemy_table.add_item(wizard_enemy_scene, 20)
