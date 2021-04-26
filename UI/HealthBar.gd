extends TextureProgress


func _ready():
	Events.connect("player_health_changed", self, "update_health")
	
func update_health(current_health, max_health) -> void:
	$Label.text = str(current_health) + "/" + str(max_health)
	max_value = max_health
	value = current_health
