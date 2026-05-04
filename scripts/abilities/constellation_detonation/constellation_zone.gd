extends Node2D

var _damage : int = 30
var _dot_interval : float = 0.5
var _lifetime : float = 5.0
var _dot_timer : float = 0.0
var _life_timer : float = 0.0
var _polygon_points : PackedVector2Array
var _markers : Array = []

@onready var area : Area2D = $Area2D
@onready var collision_polygon : CollisionPolygon2D = $Area2D/CollisionPolygon2D
@onready var visual_polygon : Polygon2D = $Polygon2D
@onready var border_line : Line2D = $Line2D
@onready var background_sprite : AnimatedSprite2D = $BackgroundSprite

func initialize( points : Array, damage: int, dot_interval: float, lifetime: float, markers : Array = [] ) -> void:
	_markers = markers
	area.collision_layer = 0 
	area.collision_mask = 3   # 3 = layers 1 and 2 combined (binary 011)
	
	_damage = damage
	_dot_interval = dot_interval
	_lifetime = lifetime
	_life_timer = lifetime
	#_polygon_points = PackedVector2Array(points)
	_polygon_points = PackedVector2Array( points )
	
	var shader_mat = background_sprite.material as ShaderMaterial
	
	#print("screen positions passed to shader:")
	for i in 4:
		
		var screen_pos = get_viewport().get_canvas_transform() * _polygon_points[i]
		#print("p", i, ": ", screen_pos)
		shader_mat.set_shader_parameter( "p" + str(i), screen_pos)
	
	var min_x = _polygon_points[0].x
	var max_x = _polygon_points[0].x
	var min_y = _polygon_points[0].y
	var max_y = _polygon_points[0].y
	
	for p in _polygon_points:
		min_x = min(min_x, p.x)
		max_x = max(max_x, p.x)
		min_y = min(min_y, p.y)
		max_y = max(max_y, p.y)
		
	var width = max_x - min_x
	var height = max_y - min_y
	#var zone_area = width * height
	var zone_size = max(width, height)
	
	var center = Vector2.ZERO
	for p in _polygon_points:
		center += p
	center /= _polygon_points.size()
	
	background_sprite.global_position = center
	#print("zone_size: ", zone_size, " width: ", width, " height: ", height)
	
	if zone_size <= 64.0:
		#print("Playing space_64")
		background_sprite.play("space_64")
	else:
		#print("Playing space_320")
		background_sprite.play("space_320")

	
	collision_polygon.polygon = _polygon_points
	
	visual_polygon.polygon = _polygon_points
	visual_polygon.color = Color( 0.0, 0.0, 0.0, 0.0 ) #Color( 0.3, 0.1, 0.8, 0.25 )
	
	var line_points = Array( _polygon_points )
	line_points.append( line_points[0] )
	border_line.points = PackedVector2Array( line_points )
	border_line.width = 1.0
	border_line.default_color = Color(0.985, 0.99, 0.78, 1.0) #Color(0.7, 0.4, 1.0)
	
func _physics_process(delta: float) -> void:
	_life_timer -= delta
	if _life_timer <= 0.0:
		for marker in _markers:
			if is_instance_valid( marker ):
				marker.queue_free()
		queue_free()
		return
		
	var shader_mat = background_sprite.material as ShaderMaterial
	for i in 4:
		var screen_pos = get_viewport().get_canvas_transform() * _polygon_points[i]
		shader_mat.set_shader_parameter("p" + str(i), screen_pos )
		
	_dot_timer -= delta
	if _dot_timer <= 0.0:
		_dot_timer = _dot_interval
		_apply_dot()
	
func _apply_dot() -> void:
	#print("applying dot, overlapping bodies: ", area.get_overlapping_bodies().size())
	for body in area.get_overlapping_bodies():
		if body is Entity:
			#print("hitting: ", body.name)
			#if body == get_tree().current_scene.get_node_or_null( "Player" ):
			if body.is_in_group("player"):
				continue
			body.apply_stun(_dot_interval + 0.1)
			body.apply_damage( _damage )
	
	
	
	
	
	
	
