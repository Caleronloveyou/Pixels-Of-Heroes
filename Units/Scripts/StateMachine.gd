# StateMachine.gd
# This node will manage the states for its parent (our Unit).

extends Node

# The current active state.
var current_state: State

# A dictionary to hold all possible states for the unit.
# We'll populate this from the Unit script.
var states: Dictionary = {}


func _ready():
	# Wait for the parent node (Unit) to be ready before initializing.
	await get_parent().ready
	# Set the initial state. 'move' will be our default state key.
	change_state("move")


func _physics_process(delta: float):
	# If there is an active state, call its physics_update function.
	if current_state:
		current_state.physics_update(delta)


# This function handles the transition between states.
func change_state(key: String):
	# Exit the current state if there is one.
	if current_state:
		current_state.exit()
	
	# Check if the new state exists in our dictionary.
	if states.has(key):
		# Set the new state as the current one.
		current_state = states[key]
		# Call the enter function of the new state.
		current_state.enter()
	else:
		print("Error: State '", key, "' not found!")
