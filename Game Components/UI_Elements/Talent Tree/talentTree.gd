extends Control
class_name TalentTree

@onready var TalentName: Label = $PanelContainer/VBoxContainer/HBoxContainer/info_margin/info_vbox/TalentName
@onready var TalentDesc: Label = $PanelContainer/VBoxContainer/HBoxContainer/info_margin/info_vbox/TalentDescription
@onready var lvl_req: Label = $"PanelContainer/VBoxContainer/HBoxContainer/info_margin/info_vbox/lvl req"


#character talents
@onready var hp: Button = $"PanelContainer/VBoxContainer/HBoxContainer/char_talents/VBoxContainer/HP+1"
@onready var shield: Button = $"PanelContainer/VBoxContainer/HBoxContainer/char_talents/VBoxContainer/Shield+"
@onready var extra_cast: Button = $"PanelContainer/VBoxContainer/HBoxContainer/char_talents/VBoxContainer/Extra Action"
@onready var attack: Button = $"PanelContainer/VBoxContainer/HBoxContainer/char_talents/VBoxContainer/Attack+"


# Called when the node enters the scene tree for the first time.
func _ready():
	TalentName.text = ""
	lvl_req.text = ""
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hp_1_pressed():
	print('talentTree sees press')
	TalentName.text = hp.talentName
	TalentDesc.text = hp.description
	lvl_req.text = str("Level Required: ",hp.required_level)


func _on_shield_pressed():
	TalentName.text = shield.talentName
	TalentDesc.text = shield.description
	lvl_req.text = str("Level Required: ",shield.required_level)


func _on_extra_action_pressed():
	TalentName.text = extra_cast.talentName
	TalentDesc.text = extra_cast.description
	lvl_req.text = str("Level Required: ",extra_cast.required_level)

func _on_attack_pressed():
	TalentName.text = attack.talentName
	TalentDesc.text = attack.description
	lvl_req.text = str("Level Required: ",attack.required_level)
