extends Node2D

@onready var hud = $PlayerHUD
@onready var player = $Bucky
@onready var orb_spawner = $OrbSpawner

func _ready() -> void:
	hud.set_player( player )

func register_mob( mob : Entity ) -> void:
	orb_spawner.connect_mob( mob )
