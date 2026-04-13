extends Ability
class_name SkillShot

var projectile_scene : PackedScene = null
var damage : int = 25
var projectile_speed : float = 600.0
var projectile_range : float = 800.0

func _execute( mouse_pos: Vector2 ) -> void:
	if projectile_scene == null:
		print("SkillShot: No projectile scene assigned!")
		return
		
	var direction = ( mouse_pos - caster.global_position).normalized()
	
	var projectile = projectile_scene.instantiate()
	projectile.direction = direction
	projectile.speed = projectile_speed
	projectile.damage = damage
	projectile.range = projectile_range
	projectile.caster = caster
	projectile.global_position = caster.global_position
	projectile.rotation = direction.angle()
	
	caster.get_tree().current_scene.add_child( projectile )
