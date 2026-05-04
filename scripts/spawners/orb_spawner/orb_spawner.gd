extends Node
class_name OrbSpawner

var orb_types : Array = []

func _ready() -> void:
	orb_types = [
		{
			"scene" : preload("res://scenes/orbs/defense_orb/defense_orb.tscn"),
			"weight" : 1.0
		},
		{
			"scene" : preload("res://scenes/orbs/neon_orb/neon_orb.tscn"),
			"weight" : 0.25
		},
	]
	
func connect_mob( mob : Entity ) -> void:
	mob.died.connect( _on_mob_died )
		
func _on_mob_died( spawn_position : Vector2 ) -> void:
	#print("Mob died at: ", spawn_position)
	var orb_scene = _roll_drop()
	if orb_scene == null:
		#print("No Orb Drop this time")
		return
		
	#print("Dropping: ", orb_scene.resource_path)
	var orb = orb_scene.instantiate()
	orb.global_position = spawn_position
	get_tree().current_scene.add_child( orb )

func _roll_drop() -> PackedScene:
	var total_weight : float = 0.0
	for entry in orb_types:
		total_weight += entry["weight"]
	var no_drop_weight : float = 2.0
	total_weight += no_drop_weight
	
	var roll : float = randf() * total_weight 
	
	if roll < no_drop_weight:
		return null
	roll -= no_drop_weight
	
	for entry in orb_types:
		roll -= entry["weight"]
		if roll <= 0.0:
			return entry["scene"]
			
	return null
		
