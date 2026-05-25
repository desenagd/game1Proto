extends Ability
class_name LightPunch

var _angle: float = PI / 3
var _cone_segments: int = 12
var cone_area: Area2D = null
var caster_pos : Vector2 = Vector2()
var damage: int
var reach: int

#TODO: Make this an ability class of its own "Melee Attack"

var _hit_effect_scene = preload("res://scenes/abilities/light_punch/light_punch_hit_effect.tscn")

func _ready() -> void:
	await super._ready()
	mana_cost = 15
	cooldown = 0.3
	damage = 35
	cast_duration = 0.3
	reach = 500

func _on_hit( target ) -> void:
	var effect = _hit_effect_scene.instantiate()
	target.add_child(effect)
	effect.position = Vector2.ZERO
	
func _execute(mouse_pos : Vector2) -> void:
	caster_pos = caster.global_position
	cone_area = Area2D.new()
	var collision_area: CollisionPolygon2D = CollisionPolygon2D.new()
	cone_area.add_child(collision_area)

	# Direction from caster to mouse
	var dir : Vector2 = (mouse_pos - caster_pos).normalized()
	
	# Get necessary polygon points, rough cone from player
	var arc_points = build_arc_points(dir, _angle, reach, _cone_segments)
	var packed_poly_points = PackedVector2Array(arc_points)
	collision_area.set_polygon(packed_poly_points)
	
	# Add a visual polygon to see attack
	var visual = Polygon2D.new()
	visual.polygon = packed_poly_points
	visual.color = Color(1.0, 0.0, 0.0, 0.3)
	cone_area.add_child(visual)

	add_child(cone_area)
	cone_area.set_collision_mask_value(2, true)

	cone_area.connect("body_entered", _on_body_entered)
	
	# Free polygon after animation finish
	await get_tree().create_timer(0.3).timeout 
	cone_area.queue_free()
	cone_area = null

func build_arc_points(dir: Vector2, half_angle: float, radius: float, segments: int) -> Array:
	# First add top of cone at origin/caster position
	var points = [Vector2.ZERO]
	# Add each point in the cone arc individually
	for index in range(segments + 1):
		var arc_pos = float(index) / float(segments)
		var angle = lerp(-half_angle, half_angle, arc_pos)
		points.append(dir.rotated(angle) * radius)
	return points

func _on_body_entered(body: Node2D) -> void:
	if body is not CharacterBody2D or body == caster or body == null:
		return
	var enemy: CharacterBody2D = body
	var to_enemy = enemy.global_position - caster_pos
	if to_enemy.length() > reach:
		return
	if enemy.has_method("apply_damage"):
		enemy.apply_damage(damage)
	if enemy.has_method("apply_knockback"):
		var direction : Vector2 = ( enemy.global_position - caster_pos ).normalized()
		body.apply_knockback( direction, 1200.0)
		
		body.is_enchained = false
	_on_hit(enemy)
