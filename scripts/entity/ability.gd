extends Node

class_name Ability

var caster : Entity
var cooldown : float = 1.0
var mana_cost : int = 1
var _cooldown_timer : float = 0.0
var is_ready : bool = true
var animation_name : String = ""

func _ready() -> void:
	await get_tree().process_frame
	var index = caster.abilities.find(self)
	animation_name = "ability_" + str(index + 1)
	#print("ability slot assigned: ", animation_name)

func _physics_process(delta: float) -> void:
	if not is_ready:
		_cooldown_timer -= delta
		if _cooldown_timer <= 0.0:  # nested inside "if not is_ready"
			is_ready = true
			
	if caster:
		var anim_tree = caster.get_node_or_null("AnimationTree")
		if anim_tree:
			var val = anim_tree["parameters/conditions/ability_1"]
			#if val:
				#print("ability_1 condition is TRUE")
		
func activate( mouse_pos : Vector2 ) -> void:
	if not is_ready:
		#print("Ability is not ready yet!")
		return
	if caster.current_mana < mana_cost:
		#print("Not Enough Mana!")
		return
		
	caster.modify_mana( -mana_cost )
	is_ready = false
	_cooldown_timer = cooldown
	_play_animation()
	_execute( mouse_pos )
	
func _play_animation() -> void:
	if animation_name == "":
		return
		
	var anim_tree = caster.get_node_or_null("AnimationTree")
	var anim_player = caster.get_node_or_null("AnimationPlayer")
	
	if anim_tree and anim_player:
		var mouse_pos = caster.get_global_mouse_position()
		var dir = (mouse_pos - caster.global_position).normalized()
		
		var blend_path = "parameters/" + animation_name + "/blend_position"
		var condition_path = "parameters/conditions/" + animation_name
		
		if anim_tree.get(blend_path) != null and anim_tree.get(condition_path) != null:
			anim_tree[blend_path] = dir
			anim_tree[condition_path] = true
		
			await caster.get_tree().create_timer(0.5).timeout
			#print("resetting condition")
			anim_tree[condition_path] = false
		
func _execute( mouse_pos : Vector2 ) -> void:
	pass
	
