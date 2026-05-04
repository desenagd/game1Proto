extends CharacterBody2D
class_name Entity

#-############## VARIABLES #################

var direction : Vector2 = Vector2()

var max_health : int = 100
var current_health : int = 100
var health_regen : int = 5
var armor : int = 0

var max_mana : int = 100
var current_mana : int = 100
var mana_regen : int = 5

var max_speed : float = 10000 #was 600
var current_speed : float = 250
var acceleration : float = 4

var agility : int = 1

var global_cooldown = 30
var is_busy : bool = false
var last_ability : int = 0

var _regen_timer : float = 0.0
const REGEN_INTERVAL : float = 1.0

var abilities : Array[Node] = []

signal died( position : Vector2 )

var is_enchained : bool = false
var is_stunned : bool = false
var _stun_timer : float = 0.0

var _knockback_velocity : Vector2 = Vector2.ZERO
var _knockback_friction : float = 15.0

#-############## FUNCTIONS ##################-#
func _physics_process(delta: float) -> void:
	
	if _knockback_velocity.length() > 1.0:
		velocity = _knockback_velocity
		_knockback_velocity = _knockback_velocity.lerp( Vector2.ZERO, _knockback_friction * delta )
		move_and_slide()
	else:
		if is_enchained and _knockback_velocity != Vector2.ZERO:
			is_enchained = false
			_knockback_velocity = Vector2.ZERO
		#is_enchained = false
	
	_regen_timer += delta
	if _regen_timer >= REGEN_INTERVAL:
		_regen_timer -= REGEN_INTERVAL
		regen_health()
		regen_mana()
		
	if is_stunned:
		_stun_timer -= delta
		if _stun_timer <= 0.0:
			is_stunned = false
			is_enchained = false
			
func regen_health():
	current_health = min( current_health + health_regen, max_health)
	
	if( current_health == max_health ):
		return
	show_heal_numbers( health_regen )
	#sprint("regen tick — health: ", current_health, " / ", max_health)
			
func regen_mana():
	current_mana = min(current_mana + mana_regen, max_mana)
			
func modify_mana( amount ):
	var new_mana = current_mana + amount
	if new_mana < 0:
		current_mana = 0
	elif new_mana > max_mana:
		current_mana = max_mana
	else:
		current_mana = new_mana
	
	
func modify_health( amount ):
	var new_health = current_health + amount
	if new_health < 0:
		current_health = 0
	elif new_health > max_health:
		current_health = max_health
	else:
		current_health = new_health
		
	if( amount == 0 ):
		return
	show_heal_numbers( amount )

		
func apply_damage(amount) -> void:
	if armor > 0:
		amount = amount * ((100 - armor) * 0.01)
	current_health -= amount
	
	flash_damage()
	show_dmg_numbers( amount )
	
	if current_health <= 0:
		current_health = 0
		die()

func die() -> void:
	died.emit( global_position )
	queue_free()  # removes the node from the scene
	
		
func load_ability( ability_name : String ) -> Node:
	var path = "res://scenes/abilities/" + ability_name + "/" + ability_name + ".tscn"
	#print("Attempting to load: ", path)
	var scene = load(path)
	if(scene == null):
		#print( "FAILD to load ability: ", path)
		return null
	
	#var scene = load("res://scenes/abilities/" + ability_name + "/" + ability_name + ".tscn")
	var sceneNode = scene.instantiate() as Ability
	if sceneNode == null:
		push_error(" Ability Scene root is not an Ability node: " + path)
		return null
		
	sceneNode.caster = self
	add_child(sceneNode)
	abilities.append(sceneNode)
	
	var index = abilities.find( sceneNode )
	sceneNode.animation_name = "ability_" + str( index + 1 )
	
	return sceneNode
	
func flash_damage() -> void:
	var sprite = get_node_or_null("Sprite2D")
	if sprite == null:
		return
	sprite.modulate = Color(1.5, 0.3, 0.3)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1,1,1)
	
func show_dmg_numbers( amount : int ) -> void:
	var label = Label.new()
	label.text = str( amount )
	label.position = Vector2( -10, -40 )
	label.z_index = 10
	add_child( label )
	
	var tween = create_tween()
	tween.tween_property(label, "position", label.position + Vector2(0, -30), 0.6)
	tween.parallel().tween_property( label, "modulate:a", 0.0, 0.6 )
	tween.tween_callback( label.queue_free )
	
func show_heal_numbers( amount : int ) -> void:
	var label = Label.new()
	label.text = str( amount )
	label.position = Vector2( -10, -40 )
	label.z_index = 10
	add_child( label )
	
	var tween = create_tween()
	tween.tween_property(label, "position", label.position + Vector2(0, -30), 0.6)
	tween.parallel().tween_property( label, "modulate:a", 0.0, 0.6 )
	tween.tween_callback( label.queue_free )

func apply_stun( duration : float ) -> void:
	is_enchained = true
	is_stunned = true
	_stun_timer = duration
	
func apply_knockback( direction: Vector2, force : float) -> void:
	is_enchained = true
	_knockback_velocity = direction * force
