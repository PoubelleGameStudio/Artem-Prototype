extends Button
class_name TalentButton

@export var talentName : String = ""
@export var description : String = ""
@export var required_level : int
@export var talentType: String = ""
@export var selected: bool
#	set(value):
#		selected = value
#		if value:
#			selected_icon.show()

@onready var line = $Line2D
@onready var displayName: Label = $name
@onready var panel = $Panel
@onready var art_path: String = "res://Sprites/combat/spell icons/"
@onready var selected_icon: Sprite2D = $select

@export var cost : int = 0

		


func _ready():
	if get_parent() is TalentButton:
		line.add_point(global_position + size/2)
		line.add_point(get_parent().global_position + size/2)
		
	if talentName:
		if !self.icon:
			self.icon = load(str(art_path,talentName,".png"))
	
	if State.level >= required_level:
		selected_icon.show()


################## SIGNALS ##################
func _on_pressed():
	if State.level >= required_level:
		selected = true
	
	
func _on_focus_entered():
	$Panel.show()


func _on_focus_exited():
	$Panel.hide()
