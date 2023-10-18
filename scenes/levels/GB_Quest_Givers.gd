extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if State.quest_db["barkeep_1"]["Status"] == 0 or State.quest_db["barkeep_1"]["Status"] == 1:
		$barkeep.show()
		$barkeep2.hide()
	else:
		$barkeep.hide()
		$barkeep2.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if State.quest_db["barkeep_1"]["Status"] == 0 or State.quest_db["barkeep_1"]["Status"] == 1:
		$barkeep.show()
		$barkeep2.hide()
	else:
		$barkeep.hide()
		$barkeep2.show()
