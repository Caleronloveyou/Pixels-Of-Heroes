# EnemySpawner.gd
# This script automatically spawns enemy units on a timer.

extends Node2D

# The scene of the unit we want the enemy to spawn.
# We will drag our Unit.tscn file into this variable in the Inspector.
@export var unit_to_spawn: PackedScene

# --- Node References ---
@onready var spawn_timer: Timer = $Timer
@onready var spawn_point: Marker2D = $SpawnPoint


func _ready():
	# Connect the timer's timeout signal to our spawning function.
	# This means every time the timer finishes, it will call _on_spawn_timer_timeout.
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)


func _on_spawn_timer_timeout():
	# First, check if the unit scene has been assigned in the editor.
	if not unit_to_spawn:
		print("Enemy spawner error: Unit scene is not set!")
		return

	# Create a new instance of the unit scene.
	var new_enemy = unit_to_spawn.instantiate()

	# IMPORTANT: We need to tell the new unit that it's on the enemy team.
	# The unit's own script (Unit.gd) will handle flipping the sprite 
	# and setting the correct physics layers based on this 'team' variable.
	new_enemy.team = 2

	# Add the new enemy to the main level scene, NOT as a child of the spawner.
	# get_parent() gets the BattleLevel node.
	get_parent().add_child(new_enemy)

	# Position the new enemy at our designated spawn point.
	new_enemy.global_position = spawn_point.global_position

	print("An enemy unit has been spawned!")
