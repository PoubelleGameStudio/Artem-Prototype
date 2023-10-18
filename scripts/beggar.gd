class_name quest_giver extends CharacterBody2D

@export var has_quest = 0
@export var new_interact = 1
@export var sprite: String = ""
@export var vendor = 0



@onready var quest = $quest_interaction





func _ready():
	$AnimatedSprite2D.play(str(sprite))

	
	
	
	
	
func _physics_process(delta):
	get_NPC_state()

func hasTalked(update):
	new_interact = update

func get_NPC_state():
	var quest_db = State.quest_db
	if (has_quest == 0):
		$dialogue_indicator.play("new_dialogue")
	#elif (new_interact == 0 and has_quest ==0):
	#	$dialogue_indicator.hide()
	elif (has_quest == 1):
		if (quest_db[quest.interact_label]["Status"] == 0):
			$dialogue_indicator.play("has_quest")
		elif (quest_db[quest.interact_label]["Status"]) == 1:
			if State.quest_complete(quest.interact_label)==false:
				$dialogue_indicator.play("quest_incomplete")
			else:
				$dialogue_indicator.play("quest_complete")
		elif (quest_db[quest.interact_label]["Status"] == 2):
			$dialogue_indicator.hide()




func _on_quest_interaction_area_entered(area):
	_ready()


func _on_quest_interaction_area_exited(area):
	_ready()
