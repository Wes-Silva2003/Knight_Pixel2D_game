extends CharacterBody2D

enum State{ idle, jump, walk, death}

const SPEED: float = 120.0
const JUMP_VELOCITY: float = -400.0

@export var MAX_JUMPS: int = 2

var jump_count : int = 0
var current_state: State = State.idle

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $HitBox
@onready var timer_death: Timer = $TimerDeath
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _physics_process(delta):
	apply_gravity(delta)
	
	# Chama a lógica de estados 
	match current_state:
		State.idle:
			idle_state(delta)
		State.walk:
			walk_state()
		State.jump:
			jump_state()
		State.death:
			dead_state(delta)

	move_and_slide()

# Controle de estados 
func change_state(new_state):
	if current_state == State.death:
		return
	
	# Evita entrar no estado duas vez a menos que seja o pulo
	if current_state == new_state and new_state != State.jump:
		return
	
	current_state = new_state
	
	# Carrega o novo estado
	match current_state:
		State.idle:
			animation.play("idle")
			jump_count = 0
			velocity.x = 0
		State.walk:
			animation.play("walk")
			jump_count = 0
		State.jump:
			animation.play("jump")
		State.death:
			animation.play("dead")
			velocity = Vector2.ZERO

func idle_state(_delta):
	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("jump"):
		perform_jump()
	elif Input.get_axis("left", "right"):
		change_state(State.walk)

func walk_state():
	var direction = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump"):
		perform_jump()
	elif direction:
		velocity.x = direction * SPEED
		animation.flip_h = direction < 0
	else:
		change_state(State.idle)
	
func jump_state():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		animation.flip_h = direction < 0
	if Input.is_action_just_pressed("jump") and check_jump():
		perform_jump()
	
	if is_on_floor():
		if direction:
			change_state(State.walk)
		else:
			change_state(State.idle)
	
func dead_state(_delta):
	if timer_death.is_stopped():
		timer_death.start()
	
func check_jump() -> bool:
	return jump_count < MAX_JUMPS

func perform_jump():
	velocity.y = JUMP_VELOCITY
	jump_count += 1
	change_state(State.jump)

# Add the gravity.
func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
