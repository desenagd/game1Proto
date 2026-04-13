extends CharacterBody2D

class_name Entity

var direction : Vector2 = Vector2()

var max_health : int = 100
var current_health : int = 100
var health_regen : int = 5
var armor : int = 0

var max_mana : int = 100
var current_mana : int = 100
var mana_regen : int = 5

var max_speed : float = 250 #was 600
var current_speed : float = 250
var acceleration : float = 4

var agility : int = 1

var global_cooldown = 30
var is_busy : bool = false
var last_ability : int = 0

var _regen_timer : float = 0.0
const REGEN_INTERVAL : float = 60.0

var abilities : Array[Node] = []

func regen_health():
	if (current_health < max_health):
		if( current_health + health_regen) > max_health:
			current_health = max_health
		else:
			current_health += health_regen
			
func regen_mana():
	if (current_mana < max_mana):
		if( current_mana + mana_regen) > max_mana:
			current_mana = max_mana
		else:
			current_mana += mana_regen
			
func modify_mana( amount ):
	var new_mana = current_mana + amount
	if( new_mana < 0):
		current_mana = 0
	if( new_mana > max_mana):
		current_mana = max_mana
	else:
		current_mana += amount
		
func apply_damage(amount) -> void:
	if armor > 0:
		amount = amount * ((100 - armor) * 0.01)
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		die()

func die() -> void:
	queue_free()  # removes the node from the scene
		
func _physics_process(delta: float) -> void:
	_regen_timer += delta
	if _regen_timer >= REGEN_INTERVAL:
		_regen_timer -= REGEN_INTERVAL
		regen_health()
		regen_mana()
		
func load_ability( ability_name : String ) -> Node:
	var path = "res://scenes/abilities/" + ability_name + "/" + ability_name + ".tscn"
	print("Attempting to load: ", path)
	var scene = load(path)
	if(scene == null):
		print( "FAILD to load ability: ", path)
		return null
	
	#var scene = load("res://scenes/abilities/" + ability_name + "/" + ability_name + ".tscn")
	var sceneNode = scene.instantiate()
	sceneNode.caster = self
	add_child(sceneNode)
	abilities.append(sceneNode)
	return sceneNode
	
	
