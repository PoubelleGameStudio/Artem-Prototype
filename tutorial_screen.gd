extends Control

@export var title: String
@export var next_title: String
@onready var title_label: Label = $PanelContainer/MarginContainer/VBoxContainer/title
@onready var text_label: Label = $PanelContainer/MarginContainer/VBoxContainer/text



# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	if State.tutorials[title]["seen"] == 0:
		populate_tutorial(title)

func populate_tutorial(tutorial: String) -> void:
	title_label.text = tutorial
	text_label.text = State.tutorials[tutorial]["text"]
	State.tutorials[tutorial]["seen"] = 1
	$PanelContainer/MarginContainer/VBoxContainer/Button.grab_focus()
	show()
	
func _on_button_pressed():
	if next_title:
		pass
	else:
		queue_free() # Replace with function body.
