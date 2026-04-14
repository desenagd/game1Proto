extends AnimatedSprite2D
class_name LightPunchHitEffect

func _ready() -> void:
	animation_finished.connect( _on_animation_finished)
	play("hit")

func _on_animation_finished() -> void:
	queue_free()
