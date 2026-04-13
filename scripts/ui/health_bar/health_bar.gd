extends Node2D

class_name HealthBar

@onready var _progress_bar : ProgressBar = $ProgressBar

func _ready() -> void:
	top_level = true
	_progress_bar.add_theme_stylebox_override("fill", _progress_bar.get_theme_stylebox("fill").duplicate())
	

	
func update(current: int, maximum: int) -> void:
	_progress_bar.max_value = maximum
	_progress_bar.value = current

	var percent = float(current) / float(maximum)
	var fill_style = _progress_bar.get_theme_stylebox("fill") as StyleBoxFlat
	
	if percent > 0.6:
		fill_style.bg_color = Color.GREEN
	elif percent > 0.3:
		fill_style.bg_color = Color.YELLOW
	else:
		fill_style.bg_color = Color.RED
