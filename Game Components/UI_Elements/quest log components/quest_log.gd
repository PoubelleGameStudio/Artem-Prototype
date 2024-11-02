extends Control

@onready var all_quests = State.quest_db

# Called when the node enters the scene tree for the first time.
func _ready():
	populate_log()
	#quests.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
	
func populate_log():
	var log = State.quest_db.keys()
	var cards = get_node("ScrollContainer/quests").get_children()
	var step = 0
	for quest in log:
		
		if all_quests[quest]["Status"]==1:
			cards[step].quest_name = all_quests[quest]["quest_name"]
			cards[step].quest_desc =  all_quests[quest]["description"]
			if State.quest_complete(quest):
				cards[step].status = "Complete!"
			else:
				cards[step].status = "In Progress"
			cards[step].show()
			step += 1
		if all_quests[quest]["Status"]==2:
			if cards[step].quest_name == all_quests[quest]["quest_name"]:
				cards[step].quest_name = ""
				cards[step].quest_desc =  ""
				cards[step].status = ""
				cards[step].hide()
			step += 1
