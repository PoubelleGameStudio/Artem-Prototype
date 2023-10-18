extends AnimatedSprite2D

@onready var itemInteract = $interaction
@onready var amount = int(itemInteract.interact_value)

# Called when the node enters the scene tree for the first time.
func _ready():
	play(itemInteract.interact_label)
	check_amount()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_amount()
	
func check_amount():
	if amount == 0:
		visible = false
		itemInteract.hide()
