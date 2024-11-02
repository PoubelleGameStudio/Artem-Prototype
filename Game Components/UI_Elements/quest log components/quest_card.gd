extends Panel

@export var quest_name = ""
@export var quest_desc = ""
@export var status = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/HBoxContainer/quest_name.text = str("- ",quest_name)
	$MarginContainer/VBoxContainer/quest_desc.text = quest_desc
	$MarginContainer/VBoxContainer/quest_status.text = str("Progress: ",status)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if quest_name:
		$MarginContainer/VBoxContainer/HBoxContainer/quest_name.text = str("- ",quest_name)
	else:
		$MarginContainer/VBoxContainer/HBoxContainer/quest_name.text = str(quest_name)
	$MarginContainer/VBoxContainer/quest_desc.text = quest_desc
	$MarginContainer/VBoxContainer/quest_status.text = str(status)
