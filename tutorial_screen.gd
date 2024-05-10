extends Control

@export var title: String
@onready var title_label: Label = $PanelContainer/MarginContainer/VBoxContainer/title
@onready var text_label: Label = $PanelContainer/MarginContainer/VBoxContainer/text



# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	if State.tutorials[title]["seen"] == 0:
		
		title_label.text = title
		text_label.text = State.tutorials[title]["text"]
		State.tutorials[title]["seen"] = 1
		show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$PanelContainer/MarginContainer/VBoxContainer/Button.grab_focus()


func _on_button_pressed():
	queue_free() # Replace with function body.
