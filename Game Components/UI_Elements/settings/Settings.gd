extends Control
class_name Settings

# buttons
@onready var toggle_mute_sound: CheckButton = $HBoxContainer/list/mute_sound/toggle_mute_sound
@onready var toggle_hide_control_hints: CheckButton = $"HBoxContainer/list/hide control hints/toggle_hide_control_hints"
@onready var effect_slider: HSlider = $"HBoxContainer/list/Effect Volume/effect_slider"
@onready var music_slider: HSlider = $"HBoxContainer/list/Music Volume/combat_music_slider"
@onready var master_slider: HSlider	 = $"HBoxContainer/list/master music volume/master_slider"

func _ready():
	set_focus()


func set_focus():
	if State.control_schema == "gamepad":
		$MainMenu.set_focus()

# signal funcs
#func _on_toggle_mute_sound_toggled(button_pressed):
	#if State.mute_sound:
		#State.mute_sound = false
	#else:
		#State.mute_sound = true
		#combat_music_slider.value = combat_music_slider.min_value
		#music_slider.value = world_music_slider.min_value
		#
#
func _on_toggle_hide_control_hints_toggled(button_pressed):
	if State.hide_control_hints:
		State.hide_control_hints = false
	else:
		State.hide_control_hints = true


#func _on_world_music_slider_drag_ended(value_changed):
	#State.world_music_slider_value = music_slider.value
#
#
#
#func _on_combat_music_slider_drag_ended(value_changed):
	#State.combat_music_slider_value = combat_music_slider.value
	#print(combat_music_slider.value)
#
#
#func _on_combat_music_slider_value_changed(value):
	#State.combat_music_slider_value = value
	#print(value)
#
#
#func _on_world_music_slider_value_changed(value):
	#State.world_music_slider_value = value
	#print(value)
