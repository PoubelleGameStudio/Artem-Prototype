extends Control

@export var title: String
@export var next_title: String
@export var node_to_focus: Button

@onready var title_label: Label = $PanelContainer/MarginContainer/VBoxContainer/title
@onready var text_label: Label = $PanelContainer/MarginContainer/VBoxContainer/text
@onready var close_button: Button = $PanelContainer/MarginContainer/VBoxContainer/close_button

signal return_focus

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _process(delta):
	if get_viewport().gui_get_focus_owner():
		if get_viewport().gui_get_focus_owner().name != "close_button" and self.visible:
			close_button.grab_focus()
	

func populate_tutorial() -> void:
	title_label.text = title
	text_label.text = State.tutorials[title]["text"]
	State.tutorials[title]["seen"] = 1
	close_button.grab_focus()
	show()
	
func _on_button_pressed():
	print("clicked the close button")
	if next_title:
		get_node(str("../",next_title)).populate_tutorial()
		queue_free()
	else:
		if node_to_focus:
			node_to_focus.grab_focus()
		else:
			return_focus.emit()
			print(str(title," return focus emit"))
		queue_free()
