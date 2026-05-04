extends PointAndClick

const IMPACT_DELAY : float = 1.5
const IMPACT_RADIUS : float = 64.0
var meteor_damage : int = 80

func _ready() -> void:
	#await super._ready()
	
	mana_cost = 10
	cooldown = 0
	reach = 150.0
	damage = 0
	meteor_damage = 80
	
func _execute( mouse_pos : Vector2 ) -> void:
	var dist := caster.global_position.distance_to( mouse_pos )
	if dist > reach:
		return
	
	var strike_scene = preload( "res://scenes/abilities/planetary_impact/impact_explosion.tscn" )
	var strike = strike_scene.instantiate()
	caster.get_tree().current_scene.add_child( strike )
	strike.initialize(mouse_pos, IMPACT_DELAY, IMPACT_RADIUS, meteor_damage)
	
func _on_hit( target ) -> void:
	pass
