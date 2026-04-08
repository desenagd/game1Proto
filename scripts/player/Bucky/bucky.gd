extends CharacterBody2D

@export var player_speed : float = 650

@onready var _animation_tree : AnimationTree = $AnimationTree

var direction : Vector2 = Vector2.ZERO

func _ready() -> void:
	_animation_tree.active = true


func _physics_process(delta) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	velocity = direction * player_speed
	move_and_slide()
	update_animation_parameters()

	if direction:
		velocity = direction * player_speed
	else:
		velocity = Vector2.ZERO

func update_animation_parameters():
	if velocity == Vector2.ZERO:
		_animation_tree["parameters/conditions/isIdle"] = true
		_animation_tree["parameters/conditions/isWalking"] = false
	else:
		_animation_tree["parameters/conditions/isIdle"] = false
		_animation_tree["parameters/conditions/isWalking"] = true

	if direction != Vector2.ZERO:
		_animation_tree["parameters/idle/blend_position"] = direction
		_animation_tree["parameters/walk/blend_position"] = direction
