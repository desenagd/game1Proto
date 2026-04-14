extends Ability
class_name Dash

var dash_distance : float = 100.0
var dash_speed : float = 1000.0
var _is_dashing : bool = false
var _dash_direction = Vector2.ZERO
var _distance_traveled : float = 0.0

func _execute( mouse_pos: Vector2 ) -> void:
	if caster.direction == Vector2.ZERO:
		#print("no direction, cant dash")
		return 
		
	#print("dash_speed: ", dash_speed, " dash_distance: ", dash_distance)
	_is_dashing = true
	_dash_direction = caster.direction
	_distance_traveled = 0.0
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if _is_dashing:
		#print("dashing, distance traveled: ", _distance_traveled)
		#var movement = _dash_direction * dash_speed * delta
		caster.velocity = _dash_direction * dash_speed
		#caster.move_and_slide()
		_distance_traveled += (_dash_direction * dash_speed * delta).length()
		
		if _distance_traveled >= dash_distance:
			#print("dash complete")
			_is_dashing = false
			caster.velocity = Vector2.ZERO
