extends Node2D
class_name AiController

var entity : Entity
var target : Entity
var detection_radius : float = 600.0
var attack_radius : float = 50.0

func _physics_process(delta) -> void:
	if not entity:
		entity = get_parent() as Entity
		return
	if not target:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			target = players[0] as Entity
		return
		
	if entity.is_enchained:
		return
		
	if entity.is_stunned:
		entity.velocity = Vector2.ZERO
		entity.move_and_slide()
		return
	
	var distance = entity.global_position.distance_to(target.global_position)
	#print("distance: ", distance)
	
	if distance <= attack_radius:
		entity.velocity = Vector2.ZERO
		entity.move_and_slide()
		if entity.abilities.size() > 0:
			entity.abilities[0].activate(target.global_position)
	elif distance <= detection_radius:
		entity.direction = (target.global_position - entity.global_position).normalized()
		entity.velocity = entity.direction * entity.current_speed
		entity.move_and_slide()
	else:
		entity.velocity = Vector2.ZERO
		entity.move_and_slide()
