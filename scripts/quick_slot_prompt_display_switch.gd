extends Control

@onready var kbd_prompt: Control = $keyboard_slot_labels
@onready var gamepad_prompt: Control = $gamepad_slot_labels

# Called when the node enters the scene tree for the first time.
func _ready():
	check_for_prompts()
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_for_prompts()

func check_for_prompts() -> void:
	if State.control_schema == "mkb":
		kbd_prompt.show()
		gamepad_prompt.hide()
	elif State.control_schema == "gamepad":
		gamepad_prompt.show()
		kbd_prompt.hide()
