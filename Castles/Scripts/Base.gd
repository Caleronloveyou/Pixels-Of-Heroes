# Base.gd
# Script for the player's and enemy's main base.

extends StaticBody2D

# --- Signals ---
# This signal will be emitted when the base's health reaches zero.
# We'll pass the team number so the game knows who lost.
signal no_health(team_that_lost)

# --- Variables ---
@export var max_health: int = 1000
@export var health: int = 1000
# 1 for player's base, 2 for enemy's base
@export var team: int = 1

# --- Node References ---
@onready var health_bar: ProgressBar = $ProgressBar


func _ready():
	# Configure the base's physics layer based on its team.
	# This is crucial so that enemy units can detect it.
	if team == 1:
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
	else: # team == 2
		set_collision_layer_value(1, false)
		set_collision_layer_value(2, true)

	# Initialize the health bar
	health_bar.max_value = max_health
	health_bar.value = health


# --- Combat Logic ---
# This function can be called by units to deal damage to the base.
func take_damage(damage: int):
	health -= damage
	health_bar.value = health
	print("Base of team ", team, " took damage. Health is now ", health)
	
	if health <= 0:
		# The base is destroyed!
		# We emit the signal and then remove the base from the game.
		no_health.emit(team)
		queue_free()
