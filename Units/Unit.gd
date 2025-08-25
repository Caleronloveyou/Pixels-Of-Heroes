# Unit.gd
# Full script for a combat unit.

extends CharacterBody2D

# --- Variables ---
@export var move_speed: float = 50.0
@export var health: int = 100
@export var max_health: int = 100
@export var attack_damage: int = 10
@export var attack_rate: float = 1.0 # Attacks per second

# 1 for player, 2 for enemy
@export var team: int = 1

# --- Private Variables ---
var direction: int = 1
var target: Node2D = null
var is_moving: bool = true

# --- Node References ---
@onready var detection_zone: Area2D = $DetectionZone
@onready var attack_timer: Timer = $AttackTimer
@onready var health_bar: ProgressBar = $ProgressBar


func _ready():
	# Configure the unit based on its team
	if team == 1:
		direction = 1
		# Player units are on physics layer 1 and detect layer 2
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		detection_zone.set_collision_mask_value(1, false)
		detection_zone.set_collision_mask_value(2, true)
	else: # team == 2
		direction = -1
		# Enemy units are on physics layer 2 and detect layer 1
		set_collision_layer_value(1, false)
		set_collision_layer_value(2, true)
		detection_zone.set_collision_mask_value(1, true)
		detection_zone.set_collision_mask_value(2, false)
		# Flip the sprite for the enemy
		$Sprite2D.flip_h = true


	# Set up the attack timer
	attack_timer.wait_time = 1.0 / attack_rate
	
	# Connect signals
	detection_zone.body_entered.connect(_on_detection_zone_body_entered)
	detection_zone.body_exited.connect(_on_detection_zone_body_exited)
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	
	# Initialize health bar
	health_bar.max_value = max_health
	health_bar.value = health


func _physics_process(delta: float):
	if is_moving and not target:
		velocity.x = move_speed * direction
	else:
		velocity.x = 0

	move_and_slide()


# --- Combat Logic ---

func take_damage(damage: int):
	health -= damage
	health_bar.value = health
	print(self.name, " took ", damage, " damage. Health is now ", health)
	if health <= 0:
		queue_free() # The unit dies

func attack_target():
	if target and is_instance_valid(target):
		target.take_damage(attack_damage)
	else:
		# Target is dead or gone, reset state
		target = null
		is_moving = true


# --- Signal Callbacks ---

func _on_detection_zone_body_entered(body: Node2D):
	# Check if we don't have a target yet and the detected body is an enemy
	if not target and body.has_method("take_damage"):
		target = body
		is_moving = false
		attack_timer.start()

func _on_detection_zone_body_exited(body: Node2D):
	# If our current target leaves the area, start moving again
	if body == target:
		target = null
		is_moving = true
		attack_timer.stop()

func _on_attack_timer_timeout():
	attack_target()
	# If target is still valid, attack again after cooldown
	if target and is_instance_valid(target):
		attack_timer.start()
	else:
		target = null
		is_moving = true

# this is some bullshit for a progressbar but I didn't figure it out yet -Cal
func _on_reset_visibility_timeout() -> void:
	pass # Replace with function body.
	#I just added this useless text to push changes
