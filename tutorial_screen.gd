extends Control

@export var title: String
@export var next_title: String
@onready var title_label: Label = $PanelContainer/MarginContainer/VBoxContainer/title
@onready var text_label: Label = $PanelContainer/MarginContainer/VBoxContainer/text



# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	if title == "Welcome!" and State.tutorials[title]["seen"] == 0:
		populate_tutorial()

func populate_tutorial() -> void:
	title_label.text = title
	text_label.text = State.tutorials[title]["text"]
	State.tutorials[title]["seen"] = 1
	$PanelContainer/MarginContainer/VBoxContainer/Button.grab_focus()
	show()
	
func _on_button_pressed():
	if next_title:
		print(next_title)
		print(get_node(str("../",next_title)).title)
		get_node(str("../",next_title)).populate_tutorial()
		queue_free()
	else:
		queue_free() # Replace with function body.
