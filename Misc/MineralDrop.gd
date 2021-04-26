extends Node2D

func player_collect():
	Events.emit_signal("mineral_drop_collected")
