extends Area2D
class_name SkillShotProjectile

var direction : Vector2 = Vector2.RIGHT

var speed : float = 600.00
var damage : int = 25
var range : float = 800.0
var caster : Entity = null

var _distance_traveled : float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _physics_process(delta: float) -> void:
	var movement = direction * speed * delta
	position += movement
	_distance_traveled += movement.length()
	
	if _distance_traveled >= range:
		queue_free()
		
func _on_body_entered(body: Node) -> void:
	if body == caster:
		return
	if body.has_method("apply_damage"):
		body.apply_damage( damage )
	queue_free()
