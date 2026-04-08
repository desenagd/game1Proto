extends CharacterBody2D

@onready var anim = %playerModel

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 650
	move_and_slide()
	
	var anim_name = "idle"
	
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				anim_name = "move_right"
			else:
				anim_name = "move_left"
		else:
			if( direction.y > 0):
				anim_name = "move_down"
			else:
				anim_name = "move_up"
			
	if anim.animation != anim_name:
		anim.play(anim_name)
	
	
	
