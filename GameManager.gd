extends Node

var current_level = 0
var current_depth = 0
var levels_per_depth = 4

func _ready():
	randomize()
	Events.connect("entered_new_level", self, "entered_new_level")
	Events.connect("restart_game", self, "restart_game")

func restart_game():
	current_level = 0
	current_depth = 0

func entered_new_level():
	current_level += 1
	if current_level % levels_per_depth == 0:
		current_depth += 1
		Events.emit_signal("depth_changed", current_depth)

