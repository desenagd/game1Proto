extends Ability
class_name LightPunch

var damage : int = 3
var reach : float = 100.0

func _execute(mouse_pos : Vector2) -> void:
	print("Light punch executed!")
	
	var direction = (mouse_pos - caster.global_position).normalized()
	var anim_player = get_node("AnimationPlayer")
	print("anim_player: ", anim_player)
	
	if(direction.x >= 0):
		print("playing ability_1_right")
		anim_player.play("ability_1_right")
		print("current animation: ", anim_player.current_animation)
	else:
		print("playing ability_1_left")
		anim_player.play("ability_1_left")
		print("current animation: ", anim_player.current_animation)
	
	var space = caster.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		caster.global_position,
		caster.global_position + direction * reach
	)
	
	var result = space.intersect_ray(query)
	if result and result.collider.has_method("apply_damage"):
		result.collider.apply_damage(damage)
		print("Hit: ", result.collider.name)
