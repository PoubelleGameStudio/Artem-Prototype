extends TextureButton
class_name TalentButton

@export var talentName : String = ""
@export var description : String = ""
@export var maxRank : int
@export var required_level : int

@onready var line = $Line2D
@onready var pop_up = $Label
@onready var label = $MarginContainer/Label
@onready var panel = $Panel
@export var rank : int = 0:
	set(value):
		rank = value
		State.talents[talentName] = rank
		label.text = str(rank)+ "/" + str(maxRank)


func _ready():
	if get_parent() is TalentButton:
		line.add_point(global_position + size/2)
		line.add_point(get_parent().global_position + size/2)


		
		

func is_max():
	if rank == maxRank:
		return true
	else:
		return false

################## SIGNALS ##################
func _on_pressed():
	if get_parent() is TalentButton: #&& State.level >= required_level:
		if get_parent().is_max() == true:
			rank = min(rank+1, maxRank)
			panel.show_behind_parent = true
			
			line.default_color = Color(0.9026962518692, 0.48281198740005, 1)
	else:
		rank = min(rank+1, maxRank)
		panel.show_behind_parent = true
		
		line.default_color = Color(0.9026962518692, 0.48281198740005, 1)
	
	
	
func _on_mouse_entered():
	pop_up.text = description
	pop_up.show()
	
func _on_mouse_exited():
	pop_up.hide()
	



