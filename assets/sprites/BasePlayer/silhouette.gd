class_name Player
extends CharacterBody2D

@export var player_speed : float = 300
@export var animation_tree : AnimationTree

var input : Vector2
var playback : AnimationNodeStateMachinePlayback

func _ready() -> void:
	playback = animation_tree["parameters/playback"]


func _physics_process(delta: float) -> void:
	input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input * player_speed
	move_and_slide()
	select_animation()
	update_animation_parameters()


func select_animation():
	if velocity == Vector2.ZERO:
		playback.travel("Idle")
	else:
		playback.travel("Walk")


func update_animation_parameters():
	if input == Vector2.ZERO:
		return
		
	animation_tree["parameters/Idle/blend_position"] = input
	animation_tree["parameters/Walk/blend_position"] = input
