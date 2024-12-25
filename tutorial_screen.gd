extends Control

@export var title: String
@export var next_title: String
@onready var title_label: Label = $PanelContainer/MarginContainer/VBoxContainer/title
@onready var text_label: Label = $PanelContainer/MarginContainer/VBoxContainer/text
@onready var close_button: Button = $PanelContainer/MarginContainer/VBoxContainer/close_button



# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	if title == "Welcome!" and State.tutorials[title]["seen"] == 0:
		populate_tutorial()
		close_button.grab_focus()

func _process(delta):
	pass
	#close_button.grab_focus()
	#print(get_viewport().gui_get_focus_owner().name)
	

func populate_tutorial() -> void:
	title_label.text = title
	text_label.text = State.tutorials[title]["text"]
	State.tutorials[title]["seen"] = 1
	close_button.grab_focus()
	show()
	
func _on_button_pressed():
	print("clicked the close button")
	if next_title:
		print(next_title)
		print(get_node(str("../",next_title)).title)
		get_node(str("../",next_title)).populate_tutorial()
		queue_free()
	else:
		queue_free() # Replace with function body.
