extends CanvasLayer

@export var upgrade_card_scene: PackedScene
@onready var card_container: HBoxContainer = $%CardContainer


func _ready():
	get_tree().paused = true
	
func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	for upgrade in upgrades:
		var card_instace = upgrade_card_scene.instantiate()
		card_container.add_child(card_instace)
		card_instace.set_ability_upgrade(upgrade)
