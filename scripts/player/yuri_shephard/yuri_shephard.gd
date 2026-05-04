extends Entity

@onready var _animation_tree : AnimationTree = $AnimationTree
@onready var _health_bar : HealthBar = $health_bar

func _ready() -> void:
	max_health = 100
	current_health = 100
	max_mana = 300
	health_regen = 15
	mana_regen = 250
	armor = 100
	current_speed = 95
	
	_health_bar.update(current_health, max_health)
	_animation_tree.active = true
	load_ability("constellation_detonation")
	load_ability("planetary_impact")
	load_ability("black_hole_warp")

func _physics_process(delta) -> void:
	super(delta)
	_health_bar.global_position = global_position + Vector2(0, -30)
	_health_bar.update(current_health, max_health)
