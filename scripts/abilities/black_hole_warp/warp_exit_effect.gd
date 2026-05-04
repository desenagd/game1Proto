extends Node2D

signal animation_finished

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.animation_finished.connect( _on_animation_finished )
	sprite.play( "warp_exit" )

func _on_animation_finished() -> void:
	animation_finished.emit()
	queue_free()
