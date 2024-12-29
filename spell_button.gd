extends Button
class_name spell_button

@onready var selected: Sprite2D = $selected
@onready var button: Button = $"."
@onready var spell_label: Label = $spell_name
@onready var sound: AudioStreamPlayer = $AudioStreamPlayer
@onready var confirm: AudioStream = preload("res://sounds/UI/pluck_REVERB_2.wav")
@onready var focus_sound: AudioStream = preload("res://sounds/UI/block_1.wav")


@export var spell_slot: int
@export var page_name: String = ''
@export var spell_icon: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_button()

func _process(_delta):
	update_button()

		


func setup_button() -> void:
	if page_name != "talents":
		if spell_icon:
			if State["spell_book"][spell_icon]["learned"]==1:
				show()
				spell_label.text = spell_icon
				button.icon = load(str("res://Sprites/combat/spell icons/",spell_icon,".png"))
			else:
				hide()
	elif page_name == "talents":
		if State.control_schema == "gamepad":
			spell_label.hide()
		else:
			spell_label.show()
		if spell_slot > 3 and State.level < 5:
			hide()
		else:
			spell_label.show()
			set_spell_from_state()
			spell_label.text = str(spell_slot)
			button.icon = load(str("res://Sprites/combat/spell icons/",spell_icon,".png"))


func update_button() -> void:
	if page_name != "talents":
		if spell_icon:
			if State["spell_book"][spell_icon]["learned"]==1:
				show()
				#spell_label.text = spell_icon
				button.icon = load(str("res://Sprites/combat/spell icons/",spell_icon,".png"))
			else:
				hide()
	elif page_name == "talents":
		if State.control_schema == "gamepad":
			spell_label.hide()
		else:
			spell_label.show()
		
		
		if spell_slot > 3 and State.level < 5:
			hide()
		else:
			set_spell_from_state()
			button.icon = load(str("res://Sprites/combat/spell icons/",spell_icon,".png"))
			

func set_spell_from_state():
	match spell_slot:
		1:spell_icon = State.spell1
		2:spell_icon = State.spell2
		3:spell_icon = State.spell3
		4:spell_icon = State.spell4
		5:spell_icon = State.spell5
		6:spell_icon = State.spell6


func _on_focus_entered():
	if page_name != "talents":	
		if State.control_schema == 'gamepad':
			sound.set_stream(focus_sound)
			sound.play()
		selected.show()
		Input.start_joy_vibration(0,0.9,0.5,0.1)
	elif page_name == "talents" and State.control_schema == "mkb":
		$spell_name.text = spell_icon

func _on_focus_exited():
	if page_name == "talents":
		$spell_name.text = str(spell_slot)
	elif page_name != "talents":
		selected.hide()



func _on_pressed():
	if page_name != "talents":
		sound.set_stream(confirm)
		sound.play()
		State.current_spell = spell_icon
	


func _on_mouse_entered():
	if page_name == "talents" and State.control_schema == "mkb":
		pass
	elif page_name != "talents":
		selected.show()


func _on_mouse_exited():
	if page_name == "talents":
		$spell_name.text = str(spell_slot)
	elif page_name != "talents":
		selected.hide()
