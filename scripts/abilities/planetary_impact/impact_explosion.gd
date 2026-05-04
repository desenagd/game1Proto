extends Node2D

var _impact_pos : Vector2
var _damage : int = 80
var _radius : float = 64.0																	
var _delay : float = 1.5
var _has_impacted : bool = false
var _caster : Entity = null

@onready var asteroid_sprite : AnimatedSprite2D = $AsteroidSprite
@onready var explosion_sprite : AnimatedSprite2D = $ExplosionSprite
@onready var area : Area2D = $ExplosionSprite/Area2D
@onready var collision_shape : CollisionShape2D = $ExplosionSprite/Area2D/CollisionShape2D
@onready var warning_circle : Node2D = $WarningCircle
@onready var warning_line : Line2D = $WarningCircle/Line2D

func initialize( impact_pos : Vector2, delay : float, radius : float, damage : int, caster : Entity = null ) -> void:
	_impact_pos = impact_pos
	_delay = delay
	_radius = radius
	_damage = damage
	_caster = caster
	global_position = impact_pos
	asteroid_sprite.scale = Vector2(3.0, 3.0)
	explosion_sprite.scale = Vector2(3.0, 3.0)
	
	#---------Warning Circle------------#
	var points := PackedVector2Array()
	var segments := 32
	var x_radius = _radius
	var y_radius = _radius * 0.25
	warning_circle.position = Vector2( 0, 20 )
	
	for i in segments + 1:
		var angle := ( float(i) /segments ) * (PI * 2.0)
		points.append(Vector2(cos(angle) * x_radius, sin(angle) * y_radius))
		
	#print( "radius: ", _radius)
	#print("points count: ", points.size())
	#print("first point: ", points[0])
	#print("middle point: ", points[16])
	
	warning_line.points = points
	warning_line.width = 2.0
	warning_line.default_color = Color( 0.6, 0.6, 0.6, 0.4)
	
	#_setup_asteroid()
	var circle := CircleShape2D.new()
	circle.radius = _radius
	collision_shape.shape = circle
	collision_shape.disabled = true
	#_setup_explosion()
	
	var start_offset = Vector2( 0, -500 )
	asteroid_sprite.global_position = impact_pos + start_offset
	asteroid_sprite.play("fall")
	explosion_sprite.visible = false
	
	var tween := create_tween()
	tween.tween_property(
		asteroid_sprite,
		"global_position",
		impact_pos,
		_delay
	).set_trans( Tween.TRANS_QUAD).set_ease( Tween.EASE_IN )
	tween.tween_callback( _on_impact )
	
func _on_impact() -> void:
	if _has_impacted:
		return
	_has_impacted = true
	
	warning_circle.visible = false
	asteroid_sprite.visible = false
	explosion_sprite.visible = true
	explosion_sprite.play( "explode")
	
	#collision_shape.disabled = false
	var space := get_world_2d().direct_space_state
	var shape := CircleShape2D.new()
	shape.radius = _radius
	
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D( 0, _impact_pos )
	query.collision_mask = 2
	
	var results := space.intersect_shape( query )
	for result in results:
		var body = result.collider as CharacterBody2D
		if body == null:
			#print("body was null after cast")
			continue
		if body == _caster:
			#print("skipping caster")
			continue
		#print("hit body: ", body.name)
		if body.has_method( "apply_damage" ):
			#print("applying damage to: ", body.name)
			body.apply_damage( _damage )
		if body.has_method( "apply_knockback" ):
			#print("applying knockback to: ", body.name)
			var direction : Vector2 = ( body.global_position - _impact_pos ).normalized()
			body.apply_knockback( direction, 600.0)
			
			body.is_enchained = false
		#else:
			#print( "body has no apply_knockback method: ", body.name )
			
	explosion_sprite.animation_finished.connect(func ():
		await get_tree().process_frame
		explosion_sprite.visible = false
		queue_free()
		)
	
func _on_explosion_finished() -> void:
	explosion_sprite.stop()
	explosion_sprite.visible = false

	await  get_tree().process_frame
	queue_free()
	#var sheet = load(res://assets/abilities/planetary_impact/PlanetaryImpact.png)
