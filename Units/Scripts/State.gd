# State.gd
# Base class for all unit states. It's not attached to any node.
# It defines the functions that every state must have.

class_name State

# A reference to the StateMachine that owns this state.
var state_machine

# This function is called when the state machine enters this state.
func enter():
	pass

# This function is called every frame when this state is active.
func update(delta: float):
	pass

# This function is called every physics frame when this state is active.
func physics_update(delta: float):
	pass

# This function is called when the state machine exits this state.
func exit():
	pass
