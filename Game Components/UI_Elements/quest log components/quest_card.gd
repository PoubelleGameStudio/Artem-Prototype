extends Panel

@export var quest_name = ""
@export var quest_desc = ""
@export var status = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/quest_name.text = quest_name
	$MarginContainer/VBoxContainer/quest_desc.text = quest_desc
	$MarginContainer/VBoxContainer/quest_status.text = str("Progress: ",status)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$MarginContainer/VBoxContainer/quest_name.text = quest_name
	$MarginContainer/VBoxContainer/quest_desc.text = quest_desc
	$MarginContainer/VBoxContainer/quest_status.text = str("Progress: ",status)
	pass


