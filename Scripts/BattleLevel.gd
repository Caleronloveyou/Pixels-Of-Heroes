# BattleLevel.gd
# This script manages the battle scene, including resources and unit spawning.


# BattleLevel.gd
# Final version of the script for our prototype level.

extends Node2D

# --- Signals ---
signal gold_changed(new_amount)

# --- Scene & Node References ---
@export var unit_scene: PackedScene
@export var gold_label: Label
@export var player_base: Node2D # Drag your player's base here
@export var enemy_base: Node2D  # Drag the enemy's base here
@export var end_screen_scene: PackedScene # Drag EndScreen.tscn here

# --- Variables ---
var gold: int = 100:
	set(value):
		gold = value
		gold_changed.emit(gold)
var unit_cost: int = 25
var end_screen_instance: CanvasLayer


func _ready():
	# Connect signals
	
	## ITS BROKEN
	#gold_changed.connect(_on_gold_changed)
	player_base.no_health.connect(_on_base_destroyed)
	enemy_base.no_health.connect(_on_base_destroyed)
	
	# Update the label with the starting amount of gold.
	_on_gold_changed(gold)
	
	## ITS ALSO BROKEN AND I DONT KNOW HOW TO DEAL WITH IT
	# Create an instance of the end screen and add it to the scene
	#end_screen_instance = end_screen_scene.instantiate()
	#add_child(end_screen_instance)


# --- Game Over Logic ---
func _on_base_destroyed(team_that_lost: int):
	# Pause the entire game.
	get_tree().paused = true
	
	if team_that_lost == 2: # Enemy base was destroyed
		end_screen_instance.show_screen("Победа!")
	else: # Player base was destroyed
		end_screen_instance.show_screen("Поражение!")


# --- UI Handling ---
func _on_spawn_button_pressed():
	if gold >= unit_cost:
		self.gold -= unit_cost
		var new_unit = unit_scene.instantiate()
		add_child(new_unit)
		new_unit.position = Vector2(100, 250)
	else:
		print("Not enough gold! Need ", unit_cost)


# --- Signal Callbacks ---
func _on_gold_changed(new_amount: int):
	if gold_label:
		gold_label.text = "Gold: " + str(new_amount)
