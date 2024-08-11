extends Node

@export var end_screen_scene: PackedScene

func _ready():
	$%Player.health_component.died.connect(on_player_died) 


func on_player_died():
	var end_screen_instace = end_screen_scene.instantiate()
	end_screen_instace.set_defeat()
	add_child(end_screen_instace)
