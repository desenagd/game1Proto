extends Node2D

@onready var path = $Path2D/PathFollow2D
#@onready var hud = $PlayerHUD
@onready var player = $Yuri_Shephard
@onready var orb_spawner = $OrbSpawner

func _ready() -> void:
	#hud.set_player( player )
	$slime_spawner.spawn_path(path)

func register_mob( mob : Entity ) -> void:
	orb_spawner.connect_mob( mob )
