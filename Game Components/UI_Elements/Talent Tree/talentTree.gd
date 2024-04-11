extends Control
class_name TalentTree

@onready var TalentName: Label = $PanelContainer/VBoxContainer/HBoxContainer/info_margin/info_vbox/TalentName
@onready var TalentDesc: Label = $PanelContainer/VBoxContainer/HBoxContainer/info_margin/info_vbox/TalentDescription
@onready var TalentType: Label = $PanelContainer/VBoxContainer/HBoxContainer/info_margin/info_vbox/TalentType
@onready var lvl_req: Label = $"PanelContainer/VBoxContainer/HBoxContainer/info_margin/info_vbox/lvl req"
@onready var totalSpent: int = 0
@onready var ability_point_cost = $PanelContainer/VBoxContainer/HBoxContainer/info_margin/info_vbox/point_cost
@onready var ability_points_label: Label = $"PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer2/static_ability points"
@onready var ability_points: int = State.ability_points:
	set(value):
		ability_points = value
		ability_points_label.text = str("Ability Points: ",ability_points)
		


#character talents
@onready var hp: Button = $"PanelContainer/VBoxContainer/HBoxContainer/char_talents/VBoxContainer/HP+1"
@onready var hp_pressed: bool = false
@onready var shield: Button = $"PanelContainer/VBoxContainer/HBoxContainer/char_talents/VBoxContainer/Shield+"
@onready var shield_pressed: bool = false
@onready var extra_cast: Button = $"PanelContainer/VBoxContainer/HBoxContainer/char_talents/VBoxContainer/Extra Action"
@onready var extra_pressed: bool = false
@onready var attack: Button = $"PanelContainer/VBoxContainer/HBoxContainer/char_talents/VBoxContainer/Attack+"
@onready var attack_pressed: bool = false

# character spell unlocks
# Fire
@onready var kindling: Button = $"PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/VBoxContainer/invoke_spells/Sacred Kindling"
@onready var kindling_pressed: bool = false

@onready var curse: Button = $PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/VBoxContainer/invoke_spells/Curse
@onready var curse_pressed: bool = false

@onready var poison_swamp: Button = $"PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/VBoxContainer/invoke_spells/Poison Swamp"
@onready var poison_swamp_pressed: bool = false

# Void
@onready var hollowed_threats: Button = $"PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/Arcane_spells/Hollowed Threats"
@onready var hollowed_threats_pressed: bool = false

@onready var void_sight: Button = $"PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/Arcane_spells/Void Sight"
@onready var void_sight_pressed: bool = false

@onready var vapid_affliction: Button = $"PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/Arcane_spells/Vapid Affliction"
@onready var vapid_affliction_pressed: bool = false

# blood
@onready var sanguinated_shell: Button = $"PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/blood_spells/Sanguinated Shell"
@onready var sanguinated_shell_pressed: bool = false

@onready var blood_clot_homunculus: Button = $"PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/blood_spells/Blood Clot Homunculus"
@onready var blood_clot_homunculus_pressed: bool = false

@onready var blood_moon: Button = $"PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/blood_spells/Blood Moon"
@onready var blood_moon_pressed: bool = false

func _ready():
	TalentName.text = ""
	lvl_req.text = ""
	ability_point_cost.text = "Costs: "
	skill_check()


func skill_check():
	if State.t_HP:
		hp_pressed = true
		hp.selected = true
	if State.t_attack_up:
		attack_pressed = true
		attack.selected = true
	if State.t_extra_cast:
		extra_pressed = true
		extra_cast.selected = true
	if State.t_shield:
		shield_pressed = true
		shield.selected = true
	if State.t_kindling:
		kindling_pressed = true
		kindling.selected = true
	if State.t_curse:
		curse_pressed = true
		curse.selected = true
	if State.t_poison_swamp:
		poison_swamp_pressed = true
		poison_swamp.selected = true
	if State.t_hollowed_threats: 
		hollowed_threats_pressed = true
		hollowed_threats.selected = true
	if State.t_void_sight:
		void_sight_pressed = true
		void_sight.selected = true
	if State.t_vapid_affliction:
		vapid_affliction_pressed = true
		vapid_affliction.selected = true
	if State.t_sanguinated_shell:
		sanguinated_shell_pressed = true
		sanguinated_shell.selected = true
	if State.t_blood_clot_homunculus:
		blood_clot_homunculus_pressed = true
		blood_clot_homunculus.selected = true
	if State.t_blood_moon:
		blood_moon_pressed = true
		blood_moon.selected = true
	ability_points = State.ability_points


func commit_skills() -> void:
	if hp_pressed && State.level >= hp.required_level:
		State.t_HP = true
		totalSpent += hp.cost
	if attack_pressed && State.level >= attack.required_level:
		State.t_attack_up = true
		totalSpent += attack.cost
	if extra_pressed && State.level >= extra_cast.required_level:
		State.t_extra_cast = true
		totalSpent += extra_cast.cost
	if shield_pressed && State.level >= shield.required_level:
		State.t_shield = true
		totalSpent += shield.cost
	if kindling_pressed && State.level >= kindling.required_level:
		State.t_kindling = true
		totalSpent += kindling.cost
	if curse_pressed && State.level >= curse.required_level:
		State.t_curse = true
		totalSpent += curse.cost
	if poison_swamp_pressed && State.level >= poison_swamp.required_level:
		State.t_poison_swamp = true
		totalSpent += poison_swamp.cost
	if hollowed_threats_pressed && State.level >= hollowed_threats.required_level:
		State.t_hollowed_threats = true
		totalSpent += hollowed_threats.cost
	if void_sight_pressed && State.level >= void_sight.required_level:
		State.t_void_sight = true
		totalSpent += void_sight.cost
	if vapid_affliction_pressed && State.level >= vapid_affliction.required_level:
		State.t_vapid_affliction = true
		totalSpent += vapid_affliction.cost
	if sanguinated_shell_pressed && State.level >= sanguinated_shell.required_level:
		State.t_sanguinated_shell = true
		totalSpent += sanguinated_shell.cost
	if blood_clot_homunculus_pressed && State.level >= blood_clot_homunculus.required_level:
		State.t_blood_clot_homunculus = true
		totalSpent += blood_clot_homunculus.cost
	if blood_moon_pressed && State.level >= blood_moon.required_level:
		State.t_blood_moon = true
		totalSpent += blood_moon.cost


func _on_confirm_pressed():
	commit_skills()
	print("confirmed")
	State.ability_points -= totalSpent
	totalSpent = 0
	ability_points_label.text = str("Ability Points: ",State.ability_points)


func _on_hp_1_pressed():
	print('talentTree sees press')
	TalentName.text = hp.talentName
	TalentDesc.text = hp.description
	TalentType.text = str("Type: ",hp.talentType)
	lvl_req.text = str("Unlock at level: ",hp.required_level)
	ability_point_cost.text = str("Costs: ",hp.cost)
	if hp_pressed:
		hp_pressed = false
	else:
		hp_pressed = true


func _on_shield_pressed():
	TalentName.text = shield.talentName
	TalentDesc.text = shield.description
	TalentType.text = str("Type: ",shield.talentType)
	lvl_req.text = str("Unlock at level: ",shield.required_level)
	ability_point_cost.text = str("Costs: ",shield.cost)
	if shield_pressed:
		shield_pressed = false
	else:
		shield_pressed = true


func _on_extra_action_pressed():
	TalentName.text = extra_cast.talentName
	TalentDesc.text = extra_cast.description
	TalentType.text = str("Type: ",extra_cast.talentType)
	lvl_req.text = str("Unlock at level: ",extra_cast.required_level)
	ability_point_cost.text = str("Costs: ",extra_cast.cost)
	if extra_pressed:
		extra_pressed = false
	else:
		extra_pressed = true


func _on_attack_pressed():
	TalentName.text = attack.talentName
	TalentDesc.text = attack.description
	TalentType.text = str("Type: ",attack.talentType)
	lvl_req.text = str("Unlock at level: ",attack.required_level)
	ability_point_cost.text = str("Costs: ",attack.cost)
	if attack_pressed:
		attack_pressed = false
	else:
		attack_pressed = true


func _on_sacred_kindling_pressed():
	TalentName.text = kindling.talentName
	TalentDesc.text = kindling.description
	TalentType.text = str("Type: ",kindling.talentType)
	lvl_req.text = str("Unlock at level: ",kindling.required_level)
	ability_point_cost.text = str("Costs: ",attack.cost)
	if kindling_pressed:
		kindling_pressed = false
	else:
		kindling_pressed = true


func _on_curse_pressed():
	TalentName.text = curse.talentName
	TalentDesc.text = curse.description
	TalentType.text = str("Type: ",curse.talentType)
	lvl_req.text = str("Unlock at level: ",curse.required_level)
	ability_point_cost.text = str("Costs: ",curse.cost)
	if curse_pressed:
		curse_pressed = false
	else:
		curse_pressed = true


func _on_poison_swamp_pressed():
	TalentName.text = poison_swamp.talentName
	TalentDesc.text = poison_swamp.description
	TalentType.text = str("Type: ",poison_swamp.talentType)
	lvl_req.text = str("Unlock at level: ",poison_swamp.required_level)
	ability_point_cost.text = str("Costs: ",poison_swamp.cost)
	if poison_swamp_pressed:
		poison_swamp_pressed = false
	else:
		poison_swamp_pressed = true


func _on_hollowed_threats_pressed():
	TalentName.text = hollowed_threats.talentName
	TalentDesc.text = hollowed_threats.description
	TalentType.text = str("Type: ",hollowed_threats.talentType)
	lvl_req.text = str("Unlock at level: ",hollowed_threats.required_level)
	ability_point_cost.text = str("Costs: ",hollowed_threats.cost)
	if hollowed_threats_pressed:
		hollowed_threats_pressed = false
	else:
		hollowed_threats_pressed = true	


func _on_void_sight_pressed():
	TalentName.text = void_sight.talentName
	TalentDesc.text = void_sight.description
	TalentType.text = str("Type: ",void_sight.talentType)
	lvl_req.text = str("Unlock at level: ", void_sight.required_level)
	ability_point_cost.text = str("Costs: ",void_sight.cost)
	if void_sight_pressed:
		void_sight_pressed = false
	else:
		void_sight_pressed = true		


func _on_vapid_affliction_pressed():
	TalentName.text = vapid_affliction.talentName
	TalentDesc.text = vapid_affliction.description
	TalentType.text = str("Type: ",vapid_affliction.talentType)
	lvl_req.text = str("Unlock at level: ", vapid_affliction.required_level)
	ability_point_cost.text = str("Costs: ",vapid_affliction.cost)
	if vapid_affliction_pressed:
		vapid_affliction_pressed = false
	else:
		vapid_affliction_pressed = true		


func _on_sanguinated_shell_pressed():
	TalentName.text = sanguinated_shell.talentName
	TalentDesc.text = sanguinated_shell.description
	TalentType.text = str("Type: ",sanguinated_shell.talentType)
	lvl_req.text = str("Unlock at level: ",sanguinated_shell.required_level)
	ability_point_cost.text = str("Costs: ",sanguinated_shell.cost)
	if sanguinated_shell_pressed:
		sanguinated_shell_pressed = false
	else:
		sanguinated_shell_pressed = true			


func _on_blood_clot_homunculus_pressed():
	TalentName.text = blood_clot_homunculus.talentName
	TalentDesc.text = blood_clot_homunculus.description
	TalentType.text = str("Type: ",blood_clot_homunculus.talentType)
	lvl_req.text = str("Unlock at level: ",blood_clot_homunculus.required_level)
	ability_point_cost.text = str("Costs: ",blood_clot_homunculus.cost)
	if blood_clot_homunculus_pressed:
		blood_clot_homunculus_pressed = false
	else:
		blood_clot_homunculus_pressed = true	


func _on_blood_moon_pressed():
	TalentName.text = blood_moon.talentName
	TalentDesc.text = blood_moon.description
	TalentType.text = str("Type: ",blood_moon.talentType)
	lvl_req.text = str("Unlock at level: ",blood_moon.required_level)
	ability_point_cost.text = str("Costs: ",blood_moon.cost)
	if blood_moon_pressed:
		blood_moon_pressed = false
	else:
		blood_moon_pressed = true	
