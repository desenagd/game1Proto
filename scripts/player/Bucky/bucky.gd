extends Entity

#@export var player_speed : float = 250
@onready var _animation_tree : AnimationTree = $AnimationTree
@onready var _health_bar : HealthBar = $health_bar
#var punch = load_ability("punch")

func _ready() -> void:
	max_health = 150
	current_health = 150
	max_mana = 150
	health_regen = 12
	mana_regen = 5
	armor = 10
	current_speed = 312
	
	_health_bar.update(current_health, max_health)
	_animation_tree.active = true
	load_ability("light_punch")
	load_ability("rocket_punch")

func _physics_process(delta) -> void:
	super(delta)
	_health_bar.global_position = global_position + Vector2(0, -30)
	_health_bar.update(current_health, max_health)
