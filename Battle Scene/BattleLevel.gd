# BattleLevel.gd
# This script manages the battle scene, including resources and unit spawning.

extends Node2D

# --- Signals ---
# A signal to announce that the gold amount has changed.
signal gold_changed(new_amount)


# --- Variables ---

# A reference to the Unit scene we want to spawn.
@export var unit_scene: PackedScene

# A reference to the Label node that displays the gold amount.
@export var gold_label: Label

# Player's starting gold. We use a setter function to automatically emit the signal.
var gold: int = 100:
	set(value):
		gold = value
		gold_changed.emit(gold) # Announce that the gold has changed.

# Cost of one unit.
var unit_cost: int = 25


# --- Godot Lifecycle Functions ---

func _ready():
	# Connect our signal to the function that updates the label.
	gold_changed.connect(_on_gold_changed)
	# Update the label with the starting amount of gold.
	_on_gold_changed(gold)


# --- UI Handling ---

# This function is connected to the "Spawn Unit" button's 'pressed' signal.
func _on_spawn_button_pressed():
	# Check if the player has enough gold.
	if gold >= unit_cost:
		# If yes, subtract the cost. This will trigger the setter and emit the signal.
		self.gold -= unit_cost 
		print("Unit purchased! Gold remaining: ", gold)
		
		# Create a new instance of our unit scene.
		var new_unit = unit_scene.instantiate()
		
		# Add the new unit to the scene tree.
		add_child(new_unit)
		
		# Set its starting position. 
		new_unit.position = Vector2(100, 300) 
	else:
		# If not enough gold, print a message to the console.
		print("Not enough gold! Need ", unit_cost)


# --- Signal Callbacks ---

# This function is called whenever the 'gold_changed' signal is emitted.
func _on_gold_changed(new_amount: int):
	# Update the text of our label.
	if gold_label:
		gold_label.text = "Gold: " + str(new_amount)
