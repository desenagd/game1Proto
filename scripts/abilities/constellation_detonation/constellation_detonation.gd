extends PointAndClick

const MAX_MARKS = 4
const MARK_DURATION = 8.0
const ZONE_DURATION = 5.0
const DOT_INTERVAL = 1
var dot_damage = 25
var marked_enemies : Array = []

func _ready() -> void:
	await super._ready()
	mana_cost = 5
	cooldown = 0.3
	reach = 1500.0
	damage = 0

func _on_hit( target ) -> void:
	if _is_already_marked( target ):
		return
	
	_apply_mark( target )
	
func _is_already_marked( entity ) -> bool:
	for entry in marked_enemies:
		if entry.entity == entity:
			return true
	return false
	
func _apply_mark( entity ) -> void:
	#print("applying mark to: ", entity.name)
	entity.apply_stun( MARK_DURATION )
	var marker = _create_star_marker()
	entity.add_child( marker )
	
	entity.died.connect( _on_marked_enemy_died.bind( entity ) )
	
	marked_enemies.append( { "entity": entity, "timer": MARK_DURATION, "marker": marker } )
	
	if marked_enemies.size() >= MAX_MARKS:
		_trigger_constellation()
		
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	var expired = []
	for entry in marked_enemies:
		entry.timer -= delta
		if entry.timer <= 0.0:
			expired.append( entry )
	for entry in expired:
		_remove_mark( entry )
		
func _remove_mark( entry : Dictionary ) -> void:
	if is_instance_valid( entry.marker ):
		entry.marker.queue_free()
	if is_instance_valid( entry.entity ):
		if entry.entity.died.is_connected( _on_marked_enemy_died):
			entry.entity.died.disconnect( _on_marked_enemy_died)
	marked_enemies.erase( entry )

func _on_marked_enemy_died( position : Vector2, entity ) -> void:
	for entry in marked_enemies:
		if entry.entity == entity:
			_remove_mark( entry )
			break
			
func _trigger_constellation() -> void:
	#print("_trigger_constellation called, marked count: ", marked_enemies.size())
	var points = []
	var markers = []
	
	for entry in marked_enemies:
		if is_instance_valid(entry.entity):
			points.append( entry.entity.global_position )
			#print("point added: ", entry.entity.global_position)
			if is_instance_valid( entry.marker ):
				entry.marker.reparent( caster.get_tree().current_scene)
				entry.marker.global_position = entry.entity.global_position
				markers.append( entry.marker )
			entry.marker = null
		
	for entry in marked_enemies.duplicate():
		_remove_mark( entry )
	#print("total points collected: ", points.size())
	
	for entry in marked_enemies.duplicate():
			_remove_mark(entry)
			
	points = _sort_convex( points )
	_spawn_constellation_zone(points, markers)
	#print("sorted points: ", points)
	
	
func _sort_convex( points ) -> Array:
	var center = Vector2.ZERO
	for p in points:
		center += p
	center /= points.size()
	
	points.sort_custom(func(point_a, point_b):
		return atan2(point_a.y - center.y, point_a.x - center.x) < atan2(point_b.y - center.y, point_b.x - center.x)
		)
	return points
	
func _spawn_constellation_zone( points, markers ) -> void:
	#print("spawning zone with ", points.size(), " points")
	var zone = preload( "res://scenes/abilities/constellation_detonation/constellation_zone.tscn" ).instantiate()
	if zone == null:
		print("ERROR: zone scene failed to load")
		return
	caster.get_tree().current_scene.add_child( zone )
	#print("zone added to scene")
	zone.initialize( points, dot_damage, DOT_INTERVAL, ZONE_DURATION, markers)
	#print("zone initialized")
			
	
func _create_star_marker() -> Node2D:
	var marker = AnimatedSprite2D.new()
	var frames = SpriteFrames.new()
	frames.add_animation("twinkle")
	
	var sprite_sheet = load("res://assets/abilities/constellation_detonation/star_spritesheet.png")
	for i in 10:
		var atlas = AtlasTexture.new()
		atlas.atlas = sprite_sheet
		atlas.region = Rect2(i * 32, 0, 32, 32)
		frames.add_frame("twinkle", atlas)
		
	frames.set_animation_loop("twinkle", true)
	frames.set_animation_speed("twinkle", 12.0)
	marker.sprite_frames = frames
	marker.play("twinkle")
	
	marker.position = Vector2(0, 0)
	marker.z_index = 10
	
	return marker
	
	
	
	
	
