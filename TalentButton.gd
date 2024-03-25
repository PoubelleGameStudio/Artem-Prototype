extends Button
class_name TalentButton

@export var talentName : String = ""
@export var description : String = ""
@export var required_level : int
@export var talentType: String = ""
@export var selected: bool:
	set(value):
		selected = value
		if value:
			selected_icon.show()

@onready var line = $Line2D
@onready var displayName: Label = $name
@onready var panel = $Panel
@onready var art_path: String = "res://Sprites/combat/spell icons/"
@onready var selected_icon: Sprite2D = $select

@export var rank : int = 0:
	set(value):
		rank = value
		State.talents[talentName] = rank
		displayName.text = talentName
		


func _ready():
	if get_parent() is TalentButton:
		line.add_point(global_position + size/2)
		line.add_point(get_parent().global_position + size/2)
		
	if talentName:
		if !self.icon:
			self.icon = load(str(art_path,talentName,".png"))
	


################## SIGNALS ##################
func _on_pressed():
	if selected_icon.visible:
				selected_icon.hide()
	else:
		selected_icon.show()
#	print("pressed button ",talentName)
#	if get_parent() is TalentButton && State.level >= required_level:
#		if get_parent().is_max() == true:
#			rank = min(rank+1, maxRank)
#			panel.show_behind_parent = true
#
#			line.default_color = Color(0.9026962518692, 0.48281198740005, 1)
#	else:
#		rank = min(rank+1, maxRank)
#		panel.show_behind_parent = true
#
#		line.default_color = Color(0.9026962518692, 0.48281198740005, 1)
	
	
	
	
func _on_mouse_entered():
	pass
	
func _on_mouse_exited():
	pass
	



