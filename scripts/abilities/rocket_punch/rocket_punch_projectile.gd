extends SkillShotProjectile

class_name RocketPunchProjectile

func _ready() -> void:
	super._ready()
	var sprite = get_node("AnimatedSprite2D")
	if direction.x < 0:
		sprite.flip_v = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
