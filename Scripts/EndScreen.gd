# EndScreen.gd
# Controls the game over screen.

extends CanvasLayer

# --- Node References ---
@onready var result_label: Label = $Label
@onready var restart_button: Button = $Button


func _ready():
	# Hide the screen by default.
	hide()
	# Connect the button's pressed signal to the restart function.
	restart_button.pressed.connect(_on_restart_button_pressed)


# Public function to show the screen with a specific message.
func show_screen(message: String):
	result_label.text = message
	show()
	# Unpause the game so the UI can be interacted with.
	# The game logic remains paused.
	get_tree().paused = false


func _on_restart_button_pressed():
	# Unpause the game before reloading to avoid issues.
	get_tree().paused = false
	# Reload the current scene to start over.
	get_tree().reload_current_scene()
