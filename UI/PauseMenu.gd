extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var paused: = false setget set_paused

# Called when the node enters the scene tree for the first time.
func _ready():
	$PauseOverlay/VBoxContainer/Restart.grab_focus()
	set_paused(true)

func _on_Restart_pressed():
	Events.emit_signal("restart_game")

func set_paused(value: bool) -> void:
	paused = value
	# get_tree().paused = value
	$PauseOverlay.visible = value
