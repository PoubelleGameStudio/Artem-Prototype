extends Button
class_name spell_button

@onready var selected: Sprite2D = $selected
@onready var button: Button = $"."
@onready var spell_label: Label = $spell_name
@onready var sound: AudioStreamPlayer = $AudioStreamPlayer
@onready var confirm: AudioStream = preload("res://sounds/UI/pluck_REVERB_2.wav")
@onready var focus_sound: AudioStream = preload("res://sounds/UI/block_1.wav")


@export var spell_icon: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_button()

func _process(_delta):
	setup_button()


func setup_button() -> void:
	if State["spell_book"][spell_icon]["learned"]==1:
		show()
		spell_label.text = spell_icon
		button.icon = load(str("res://Sprites/combat/spell icons/",spell_icon,".png"))
	else:
		hide()


#func _on_button_pressed():




#func _on_button_mouse_entered():
	#selected.show()
#
#func _on_button_mouse_exited():
	#selected.hide()


func _on_focus_entered():
	if State.control_schema == 'gamepad':
		sound.set_stream(focus_sound)
		sound.play()
	selected.show()
	Input.start_joy_vibration(0,0.9,0.5,0.1)


func _on_focus_exited():
	selected.hide()


func _on_pressed():
	sound.set_stream(confirm)
	sound.play()
	State.spell1 = spell_icon


func _on_mouse_entered():
	grab_focus()
