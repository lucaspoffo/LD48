extends TextureProgress


func _ready():
	max_value = GameManager.levels_per_depth * 5
	value = 0
	Events.connect("entered_new_level", self, "new_level")
	
func new_level():
	value += 1
