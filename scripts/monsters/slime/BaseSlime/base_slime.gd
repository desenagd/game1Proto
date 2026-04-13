extends Entity

@onready var _health_bar : HealthBar = $health_bar

func _ready() -> void:
	max_health = 100
	current_health = 100
	current_speed = 100
	armor = 0
	
	_health_bar.update(current_health, max_health)
	load_ability("slime_melee")

func _physics_process(delta) -> void:
	super(delta)
	_health_bar.global_position = global_position + Vector2(0, -40)
	_health_bar.update(current_health, max_health)
