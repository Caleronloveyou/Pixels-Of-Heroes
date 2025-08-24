# BattleLevel.gd
# This script manages the battle scene, including resources and unit spawning.

extends Node2D

# --- Variables ---

# A reference to the Unit scene we want to spawn.
# We will drag and drop our Unit.tscn file into this variable in the Inspector.
@export var unit_scene: PackedScene

# Player's starting gold.
var gold: int = 100

# Cost of one unit.
var unit_cost: int = 25


# --- UI Handling ---

# This function will be connected to our "Spawn Unit" button's 'pressed' signal.
func _on_spawn_button_pressed():
	# Check if the player has enough gold.
	if gold >= unit_cost:
		# If yes, subtract the cost.
		gold -= unit_cost
		print("Unit purchased! Gold remaining: ", gold)
		
		# Create a new instance of our unit scene.
		var new_unit = unit_scene.instantiate()
		
		# Add the new unit to the scene tree.
		add_child(new_unit)
		
		# Set its starting position. 
		# You can create a Marker2D node named "SpawnPoint" in your scene
		# to define where units should appear.
		# For now, we'll just use a fixed coordinate.
		new_unit.position = Vector2(100, 300) 
	else:
		# If not enough gold, print a message to the console.
		print("Not enough gold! Need ", unit_cost)


func _on_button_pressed() -> void:
	pass # Replace with function body.
