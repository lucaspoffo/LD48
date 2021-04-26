extends Node2D

func player_collect():
	Events.emit_signal("health_drop_collected")
