extends Area2D
class_name Orb

var stat_bonus : int = 5
var despawn_time : float = 120.0
var spawn_weight : float = 1.0

func _ready() -> void:
	body_entered.connect( _on_body_entered )
	var timer := Timer.new()
	timer.wait_time = despawn_time
	timer.one_shot = true
	timer.timeout.connect( queue_free )
	add_child( timer )
	timer.start()
	
	var sprite = get_node_or_null( "AnimatedSprite2D" )
	if sprite:
		sprite.play("idle")
	
func _on_body_entered( body : Node ) -> void:
	if body is Entity and body.abilities.size() > 0:
		_apply_bonus( body )
		queue_free()
		
func _apply_bonus( player : Entity ) -> void:
	pass
