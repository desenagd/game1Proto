extends Entity

#@export var player_speed : float = 250
@onready var _animation_tree : AnimationTree = $AnimationTree
@onready var _health_bar : HealthBar = $health_bar
#var punch = load_ability("punch")

func _ready() -> void:
	max_health = 100
	current_health = 100
	max_mana = 300
	health_regen = 15
	mana_regen = 250
	armor = 15
	current_speed = 95
	
	_health_bar.update(current_health, max_health)
	_animation_tree.active = true
	load_ability("light_punch")
	load_ability("rocket_punch")
	load_ability("tumble")

func _physics_process(delta) -> void:
	super(delta)
	_health_bar.global_position = global_position + Vector2(0, -30)
	_health_bar.update(current_health, max_health)
