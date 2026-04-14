extends Node2D
class_name PlayerController

var entity : Entity
var _animation_tree : AnimationTree

func _ready() -> void:
	entity = get_parent() as Entity
	_animation_tree = get_parent().get_node("AnimationTree")
	print("entity: ", entity)
	print("animation_tree: ", _animation_tree)

func _physics_process(delta) -> void:
	
	if not entity:
		return
		
	var is_dashing = false
	for ability in entity.abilities:
		if ability is Dash and ability._is_dashing:
			is_dashing = true
			break
	#print("is_dashing: ", is_dashing)
		
	if not is_dashing:
		entity.direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
		if entity.direction:
			entity.velocity = entity.direction * entity.current_speed
		else:
			entity.velocity = Vector2.ZERO
		
	entity.move_and_slide()
	
	_update_animation_parameters(entity)
	
	#========= ABILITY HANDLING ==============#
	var mouse_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("ability_1") and entity.abilities.size() > 0:
		entity.abilities[0].activate(mouse_pos)
		#_animation_tree["parameters/conditions/ability_1"] = false
	if Input.is_action_just_pressed("ability_2") and entity.abilities.size() > 1:
		entity.abilities[1].activate(mouse_pos)
		#_animation_tree["parameters/conditions/ability_2"] = false
	if Input.is_action_just_pressed("ability_3") and entity.abilities.size() > 2:
		entity.abilities[2].activate(mouse_pos)
		#_animation_tree["parameters/conditions/ability_3"] = false

func _update_animation_parameters(entity: Entity) -> void:
	if entity.velocity == Vector2.ZERO:
		_animation_tree["parameters/conditions/isIdle"] = true
		_animation_tree["parameters/conditions/isWalking"] = false
	else:
		_animation_tree["parameters/conditions/isIdle"] = false
		_animation_tree["parameters/conditions/isWalking"] = true
	if entity.direction != Vector2.ZERO:
		var blend : Vector2
		if abs(entity.direction.x) >= abs(entity.direction.y):
			blend = Vector2(sign(entity.direction.x), 0)
		else:
			blend = Vector2(0, sign(entity.direction.y))
		#_animation_tree["parameters/idle/blend_position"] = entity.direction
		_animation_tree["parameters/walk/blend_position"] = blend
