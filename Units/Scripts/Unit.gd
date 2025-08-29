# Unit.gd
# Refactored to use a State Machine.
# This script now acts as the "body" or "data container" for the unit.

extends CharacterBody2D

# --- Public Variables (Configurable in Inspector) ---
@export var move_speed: float = 50.0
@export var health: int = 100
@export var max_health: int = 100
@export var attack_damage: int = 10
@export var attack_rate: float = 1.0 # Attacks per second
@export var team: int = 1

# --- Public Properties (Accessible by States) ---
var direction: int = 1
var target: Node2D = null
var is_moving: bool = true # This is now controlled by states

# --- Node References ---
@onready var state_machine: Node = $StateMachine
@onready var detection_zone: Area2D = $DetectionZone
@onready var attack_timer: Timer = $AttackTimer
@onready var health_bar: ProgressBar = $ProgressBar
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# --- Preload States ---
# We preload the state scripts to create instances of them.
var MoveState = preload("res://Units/Scripts/MoveState.gd")
var AttackState = preload("res://Units/Scripts/AttackState.gd")


func _ready():
	# --- Initialization ---
	_initialize_team_properties()
	_initialize_attack_timer()
	_initialize_health_bar()
	_initialize_state_machine()
	
	# --- Connect Signals ---
	# The unit is responsible for its "senses".
	#detection_zone.body_entered.connect(_on_detection_zone_body_entered)
	#detection_zone.body_exited.connect(_on_detection_zone_body_exited)


# --- Initialization Functions ---

func _initialize_team_properties():
	if team == 1:
		direction = 1
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		detection_zone.set_collision_mask_value(1, false)
		detection_zone.set_collision_mask_value(2, true)
	else: # team == 2
		direction = -1
		set_collision_layer_value(1, false)
		set_collision_layer_value(2, true)
		detection_zone.set_collision_mask_value(1, true)
		detection_zone.set_collision_mask_value(2, false)
		animated_sprite.flip_h = true
#I updated it to "animated_sprite" there was "sprite" before


func _initialize_attack_timer():
	attack_timer.wait_time = 1.0 / attack_rate
	attack_timer.one_shot = true

func _initialize_health_bar():
	health_bar.max_value = max_health
	health_bar.value = health

func _initialize_state_machine():
	# Create instances of our states and add them to the state machine's dictionary.
	state_machine.states = {
		"move": MoveState.new(),
		"attack": AttackState.new()
	}
	# Pass a reference of the state machine to each state so they can communicate back.
	for state in state_machine.states.values():
		state.state_machine = state_machine
		state.unit = self


# --- Combat Logic ---
# The unit is still responsible for its own health.
func take_damage(damage: int):
	health -= damage
	health_bar.value = health
	if health <= 0:
		queue_free()


# --- Signal Callbacks (Senses) ---

func _on_detection_zone_body_entered(body: Node2D):
	if not target and body.has_method("take_damage"):
		target = body

func _on_detection_zone_body_exited(body: Node2D):
	if body == target:
		target = null
