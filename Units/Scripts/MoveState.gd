# MoveState.gd
# State responsible for moving the unit forward.

extends State

# A reference to the unit (the parent of the state machine).
var unit

func _ready():
	# Get a reference to the unit node once.
	unit = state_machine.get_parent()

# When we enter this state, we make sure the unit is set to move.
func enter():
	unit.is_moving = true
## ^ ITS BROKEN



# The core movement logic goes here, in the physics update.
func physics_update(delta: float):
	# If we find a target, we immediately tell the state machine to switch to the 'attack' state.
	if unit.target:
		state_machine.change_state("attack")
		return # Stop further execution in this frame.

	# If there's no target, we move.
	if unit.is_moving:
		unit.velocity.x = unit.move_speed * unit.direction
	else:
		unit.velocity.x = 0
	
	unit.move_and_slide()

# When we exit this state (e.g., to attack), we stop the unit's movement.
func exit():
	unit.velocity.x = 0
