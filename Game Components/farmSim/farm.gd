extends Node2D

@onready var day: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func next_day() -> void:
	day += 1
	grow_crops()

	
func grow_crops() -> void:
	var crops: Array = get_children()
	
	for crop in crops:
		crop.grow_crop()
