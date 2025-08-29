# AttackState.gd
# State responsible for attacking a target.

extends State

var unit

func _ready():
	unit = state_machine.get_parent()
	# We connect the timer's signal here, within the state that uses it.
	unit.attack_timer.timeout.connect(_on_attack_timer_timeout)

# When we enter the attack state, we stop moving and start the attack timer.
func enter():
	unit.is_moving = false
	unit.attack_timer.start()

# In the physics update, we constantly check if our target is still valid.
func physics_update(delta: float):
	# If the target is gone (dead or out of range), switch back to the 'move' state.
	if not is_instance_valid(unit.target):
		unit.target = null
		state_machine.change_state("move")

# This function is called when the attack timer finishes.
func _on_attack_timer_timeout():
	# If we still have a valid target, attack it.
	if is_instance_valid(unit.target):
		unit.target.take_damage(unit.attack_damage)
		# Restart the timer for the next attack.
		unit.attack_timer.start()
	# If the target disappeared while we were waiting, switch back to moving.
	else:
		state_machine.change_state("move")

# When we exit the attack state, we make sure the timer is stopped.
func exit():
	unit.attack_timer.stop()
