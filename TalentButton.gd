extends Button
class_name TalentButton

@export var is_trait : bool
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
	
	#if State.level >= required_level:
		#selected_icon.show()


func _process(delta):
	if (is_hovered() or has_focus()) and !is_trait:
		if Input.is_action_just_pressed("quick_slot_1"):
			spell_assign(1)
		elif Input.is_action_just_pressed("quick_slot_2"):
			spell_assign(2)
		elif Input.is_action_just_pressed("quick_slot_3"):
			spell_assign(3)
		elif Input.is_action_just_pressed("quick_slot_4"):
			spell_assign(4)
		elif Input.is_action_just_pressed("quick_slot_5"):
			spell_assign(5)
		elif Input.is_action_just_pressed("quick_slot_6"):
			spell_assign(6)
			
			
			
			
################## SIGNALS ##################
func _on_pressed():
	if State.level >= required_level:
		selected = true

func spell_assign(slot: int) -> void:
	if required_level <= State.level:
		match slot:
			1:
				State.spell1 = talentName
				$"../../../../../info_margin/info_vbox/GridContainer/Spell1".spell_icon = State.spell1
				$"../../../../../info_margin/info_vbox/GridContainer/Spell1/Label".text = State.spell1
			2:
				State.spell2 = talentName
				$"../../../../../info_margin/info_vbox/GridContainer/Spell2".spell_icon = State.spell2
				$"../../../../../info_margin/info_vbox/GridContainer/Spell2/Label".text = State.spell2
			3:
				State.spell3 = talentName
				$"../../../../../info_margin/info_vbox/GridContainer/Spell3".spell_icon = State.spell3
				$"../../../../../info_margin/info_vbox/GridContainer/Spell3/Label".text = State.spell3
			4:
				State.spell4 = talentName
				$"../../../../../info_margin/info_vbox/GridContainer/Spell4".spell_icon = State.spell4
				$"../../../../../info_margin/info_vbox/GridContainer/Spell4//Label".text = State.spell4
			5:
				State.spell5 = talentName
				$"../../../../../info_margin/info_vbox/GridContainer/Spell5".spell_icon = State.spell5
				$"../../../../../info_margin/info_vbox/GridContainer/Spell5/Label".text = State.spell5
			6:
				State.spell6 = talentName
				$"../../../../../info_margin/info_vbox/GridContainer/Spell6".spell_icon = State.spell6
				$"../../../../../info_margin/info_vbox/GridContainer/Spell6/Label".text = State.spell6
	
	
func _on_focus_entered():
	$select.show()


func _on_focus_exited():
	$select.hide()


func _on_mouse_entered():
	grab_focus()
