extends Control

var count = 0

func _ready():
	Events.connect("mineral_drop_collected", self, "mineral_drop_collected")
	
func mineral_drop_collected():
	count += 1
	$Label.text = str(count)
	
