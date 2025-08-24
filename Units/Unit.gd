# Unit.gd
# Script attached to the Unit scene (CharacterBody2D)

extends CharacterBody2D

# --- Variables ---
# These variables can be adjusted in the Godot inspector for each unit.
# We are taking them directly from your GDD.

# Movement speed (from GDD: SPD)
@export var move_speed: float = 50.0 

# Movement direction. 1 = right, -1 = left.
# For the player's units it will be 1, for the enemy's -1.
var direction: int = 1 


# --- Logic ---

# _physics_process is called every physics frame. 
# It's ideal for code related to movement and physics.
func _physics_process(delta: float) -> void:
	# Create the movement vector.
	# velocity.x determines the horizontal movement.
	# velocity.y remains 0, as the unit doesn't move up or down.
	velocity.x = move_speed * direction

	# move_and_slide() is a built-in function of CharacterBody2D.
	# It moves the character along the velocity vector and automatically
	# handles collisions (e.g., with the ground).
	move_and_slide()
