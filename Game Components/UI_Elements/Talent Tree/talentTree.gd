extends Control
class_name TalentTree

@onready var TalentName: Label = $PanelContainer/VBoxContainer/HBoxContainer/info_margin/info_vbox/TalentName
@onready var TalentDesc: Label = $PanelContainer/VBoxContainer/HBoxContainer/info_margin/info_vbox/TalentDescription
@onready var lvl_req: Label = $"PanelContainer/VBoxContainer/HBoxContainer/info_margin/info_vbox/lvl req"


#character talents
@onready var hp: Button = $"PanelContainer/VBoxContainer/HBoxContainer/char_talents/VBoxContainer/HP+1"
@onready var hp_pressed: bool = false
@onready var shield: Button = $"PanelContainer/VBoxContainer/HBoxContainer/char_talents/VBoxContainer/Shield+"
@onready var shield_pressed: bool = false
@onready var extra_cast: Button = $"PanelContainer/VBoxContainer/HBoxContainer/char_talents/VBoxContainer/Extra Action"
@onready var extra_pressed: bool = false
@onready var attack: Button = $"PanelContainer/VBoxContainer/HBoxContainer/char_talents/VBoxContainer/Attack+"
@onready var attack_pressed: bool = false
@onready var talents: Dictionary = State.talents


# Called when the node enters the scene tree for the first time.
func _ready():
	TalentName.text = ""
	lvl_req.text = ""
	skill_check()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func skill_check():
	if talents["HP+"] == 1:
		hp_pressed = true
	if talents["attack"] == 1:
		attack_pressed = true
	if talents["extra_cast"] == 1:
		extra_pressed = 1
	if talents["shield"] == 1:
		shield_pressed = 1

func commit_skills() -> void:
	if hp_pressed:
		State.t_HP = true
	if attack_pressed:
		State.t_attack_up = true
	if extra_pressed:
		State.t_extra_cast = true
	if shield_pressed:
		State.t_shield = true

func _on_hp_1_pressed():
	print('talentTree sees press')
	TalentName.text = hp.talentName
	TalentDesc.text = hp.description
	lvl_req.text = str("Level Required: ",hp.required_level)
	if hp_pressed:
		hp_pressed = false
	else:
		hp_pressed = true


func _on_shield_pressed():
	TalentName.text = shield.talentName
	TalentDesc.text = shield.description
	lvl_req.text = str("Level Required: ",shield.required_level)
	if shield_pressed:
		shield_pressed = false
	else:
		shield_pressed = true


func _on_extra_action_pressed():
	TalentName.text = extra_cast.talentName
	TalentDesc.text = extra_cast.description
	lvl_req.text = str("Level Required: ",extra_cast.required_level)
	if extra_pressed:
		extra_pressed = false
	else:
		extra_pressed = true

func _on_attack_pressed():
	TalentName.text = attack.talentName
	TalentDesc.text = attack.description
	lvl_req.text = str("Level Required: ",attack.required_level)
	if attack_pressed:
		attack_pressed = false
	else:
		attack_pressed = true


func _on_confirm_pressed():
	commit_skills()
	print("confirmed")
	pass # Replace with function body.
