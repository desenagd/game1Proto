extends CanvasLayer
class_name PlayerHUD

# ─── Node references ───────────────────────────────────────────────
@onready var hp_bar        : TextureProgressBar = $Panel/VBox/StatsColumn/HPRow/HPBar
@onready var hp_label      : Label              = $Panel/VBox/StatsColumn/HPRow/HPLabel
@onready var mana_bar      : TextureProgressBar = $Panel/VBox/StatsColumn/ManaRow/ManaBar
@onready var mana_label    : Label              = $Panel/VBox/StatsColumn/ManaRow/ManaLabel
@onready var armor_label   : Label              = $Panel/VBox/StatsColumn/MiscRow/ArmorLabel
@onready var speed_label   : Label              = $Panel/VBox/StatsColumn/MiscRow/SpeedLabel
@onready var abilities_row : HBoxContainer      = $Panel/VBox/AbilitiesRow
 
# ─── State ─────────────────────────────────────────────────────────
var player      : Entity         = null
var _slot_nodes : Array[Control] = []
 
# Action names must match your InputMap entries, in ability slot order.
# Add more here if you ever add ability_4, ability_5, etc.
const ABILITY_ACTIONS : Array[String] = [
	"ability_1",
	"ability_2",
	"ability_3",
	"ability_4",
	"ability_5",
]
 
# ─── Public API ────────────────────────────────────────────────────
func set_player(p : Entity) -> void:
	player = p
	_build_ability_slots()
 
# ─── InputMap → human-readable label ──────────────────────────────
# Reads the FIRST bound event for a given action and returns a short
# display string. Handles keyboard keys, mouse buttons, and modifiers.
func _get_action_label(action : String) -> String:
	if not InputMap.has_action(action):
		return "?"
 
	var events : Array = InputMap.action_get_events(action)
	if events.is_empty():
		return "?"
 
	var event = events[0]
 
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:   return "LMB"
			MOUSE_BUTTON_RIGHT:  return "RMB"
			MOUSE_BUTTON_MIDDLE: return "MMB"
			_:                   return "M%d" % event.button_index
 
	if event is InputEventKey:
		# Use physical keycode so it matches what the player pressed
		var kc : int = event.physical_keycode
		if kc == KEY_SHIFT:   return "Shift"
		if kc == KEY_CTRL:    return "Ctrl"
		if kc == KEY_ALT:     return "Alt"
		if kc == KEY_SPACE:   return "Space"
		# OS.get_keycode_string gives "A", "F1", etc.
		return OS.get_keycode_string(kc)
 
	# Fallback for anything else (gamepad, etc.)
	return event.as_text()
 
# ─── Dynamic slot builder ───────────────────────────────────────────
func _build_ability_slots() -> void:
	for child in abilities_row.get_children():
		child.queue_free()
	_slot_nodes.clear()
 
	if player == null:
		return
 
	for i in range(player.abilities.size()):
		var action : String = ABILITY_ACTIONS[i] if i < ABILITY_ACTIONS.size() else ""
		var label  : String = _get_action_label(action) if action != "" else str(i + 1)
		var slot   : Control = _make_slot(label)
		abilities_row.add_child(slot)
		_slot_nodes.append(slot)
 
func _make_slot(key_label : String) -> Control:
	var slot := Control.new()
	slot.custom_minimum_size = Vector2(64, 64)
 
	var bg := ColorRect.new()
	bg.name = "BG"
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0.12, 0.12, 0.16, 1.0)
	slot.add_child(bg)
 
	var overlay := ColorRect.new()
	overlay.name          = "CooldownOverlay"
	overlay.anchor_left   = 0.0
	overlay.anchor_top    = 0.0
	overlay.anchor_right  = 1.0
	overlay.anchor_bottom = 1.0
	overlay.color         = Color(0.0, 0.0, 0.0, 0.65)
	overlay.visible       = false
	slot.add_child(overlay)
 
	var key_lbl := Label.new()
	key_lbl.name          = "KeyLabel"
	key_lbl.text          = key_label
	key_lbl.anchor_left   = 0.0
	key_lbl.anchor_top    = 1.0
	key_lbl.anchor_right  = 1.0
	key_lbl.anchor_bottom = 1.0
	key_lbl.offset_left   =  2.0
	key_lbl.offset_top    = -18.0
	key_lbl.offset_right  =  -2.0
	key_lbl.offset_bottom =  -2.0
	key_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	key_lbl.add_theme_font_size_override("font_size", 10)
	key_lbl.add_theme_color_override("font_color", Color(1.0, 1.0, 0.4, 1.0))
	slot.add_child(key_lbl)
 
	var cd_lbl := Label.new()
	cd_lbl.name                 = "CDLabel"
	cd_lbl.text                 = ""
	cd_lbl.anchor_left          = 0.5
	cd_lbl.anchor_top           = 0.5
	cd_lbl.anchor_right         = 0.5
	cd_lbl.anchor_bottom        = 0.5
	cd_lbl.offset_left          = -16.0
	cd_lbl.offset_top           = -10.0
	cd_lbl.offset_right         =  16.0
	cd_lbl.offset_bottom        =  10.0
	cd_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cd_lbl.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	cd_lbl.add_theme_font_size_override("font_size", 14)
	cd_lbl.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	cd_lbl.visible = false
	slot.add_child(cd_lbl)
 
	return slot
 
# ─── Per-frame updates ─────────────────────────────────────────────
func _process(_delta: float) -> void:
	if player == null:
		return
	_update_stats()
	_update_abilities()
 
func _update_stats() -> void:
	hp_bar.max_value = player.max_health
	hp_bar.value     = player.current_health
	hp_label.text    = "%d / %d" % [player.current_health, player.max_health]
 
	mana_bar.max_value = player.max_mana
	mana_bar.value     = player.current_mana
	mana_label.text    = "%d / %d" % [player.current_mana, player.max_mana]
 
	armor_label.text = "  %d" % player.armor
	speed_label.text = "  %d" % int(player.current_speed)
 
func _update_abilities() -> void:
	if player.abilities.size() != _slot_nodes.size():
		_build_ability_slots()
		return
 
	for i in range(player.abilities.size()):
		var ability : Ability   = player.abilities[i]
		var slot    : Control   = _slot_nodes[i]
		var overlay : ColorRect = slot.get_node("CooldownOverlay")
		var cd_lbl  : Label     = slot.get_node("CDLabel")
 
		if ability.is_ready:
			overlay.visible = false
			cd_lbl.visible  = false
		else:
			overlay.visible    = true
			cd_lbl.visible     = true
			var pct : float    = ability._cooldown_timer / ability.cooldown
			overlay.anchor_top = 1.0 - pct
			cd_lbl.text        = "%.1f" % ability._cooldown_timer
