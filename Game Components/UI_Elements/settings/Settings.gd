extends Control
class_name SettingsMenu

# buttons
@onready var toggle_mute_sound: CheckButton = $"HBoxContainer/list/mute sound/toggle_mute_sound"
@onready var toggle_hide_control_hints: CheckButton = $"HBoxContainer/list/hide control hints/toggle_hide_control_hints"

# setting configs
@onready var mute_sound: bool = false
@onready var hide_control_hints: bool = false




# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# signal funcs
func _on_toggle_mute_sound_toggled(button_pressed):
	if mute_sound:
		mute_sound = false
	else:
		mute_sound = true



func _on_toggle_hide_control_hints_toggled(button_pressed):
	if hide_control_hints:
		hide_control_hints = false
	else:
		hide_control_hints = true


