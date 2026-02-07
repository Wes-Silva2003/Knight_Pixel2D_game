extends CharacterBody2D

enum State{ idle, jump, walk, hurt, death, win}

const SPEED: float = 120.0
const JUMP_VELOCITY: float = -350.0

@export var MAX_JUMPS: int = 2

var jump_count : int = 0
var current_state: State = State.idle

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $HitBox
@onready var timer_damage: Timer = $TimerDamage
@onready var timer_death: Timer = $TimerDeath
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurt_sound: AudioStreamPlayer2D = $effects_sounds/hurt_sound
@onready var jump_sound: AudioStreamPlayer2D = $effects_sounds/jump_sound
@onready var death_sound: AudioStreamPlayer2D = $effects_sounds/death_sound
@onready var win_sound: AudioStreamPlayer2D = $effects_sounds/win_sound

func _ready() -> void:
	animation.animation_finished.connect(_on_animation_finished)
	GameManager.state_win.connect(win_state)
	
	add_to_group("Player")

	# Se existir uma posição carregada no GameManager, é carregada
	if GameManager.has_load_position:
		global_position = GameManager.load_position
		GameManager.has_load_position = false 

func _physics_process(delta):
	apply_gravity(delta)
	
	#Máquina de estados e loógica
	match current_state:
		State.idle:
			idle_state(delta)
		State.walk:
			walk_state()
		State.jump:
			jump_state()
		State.hurt:
			hurt_state()
		State.death:
			death_state(delta)
		State.win:
			win_state()

	move_and_slide()

# Controle de estados 
func change_state(new_state):
	if current_state == State.death:
		return
	
	if current_state == new_state and new_state != State.jump:
		return
	
	current_state = new_state
	
	#maquina de estado para animação e som
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
			jump_sound.play()
		State.hurt:
			animation.play("hurt")
			hurt_sound.play()
			velocity = Vector2.ZERO
		State.death:
			animation.play("death")
			death_sound.play()
			velocity = Vector2.ZERO
		State.win:
			animation.play("win")
			win_sound.play()
			velocity = Vector2.ZERO

#lógicas dos estados
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

	# Morte por queda (buraco)
	if position.y >= 448 or position.x < -10:
		change_state(State.death)

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
			
	# Morte por queda (buraco)
	if position.y >= 448 or position.x < -10:
		change_state(State.death)

func hurt_state():
	if timer_damage.is_stopped():
		timer_damage.start()
		disable_hitbox()

func death_state(_delta):
	if timer_death.is_stopped():
		timer_death.start()

func win_state():
	change_state(State.win)

#funções auxiliares
func check_jump() -> bool:
	return jump_count < MAX_JUMPS

func perform_jump():
	velocity.y = JUMP_VELOCITY
	jump_count += 1
	change_state(State.jump)

func _on_timer_damage_timeout() -> void:
	enable_hitbox()

func _on_timer_death_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _on_hit_box_area_entered(area: Area2D) -> void:
	if velocity.y > 0:
		area.get_parent().take_damage()
		perform_jump()
	else:
		GameManager.lifes -= 1
		if GameManager.lifes == 0:
			change_state(State.death)
		else:
			change_state(State.hurt)

func disable_hitbox():
	hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	
func enable_hitbox():
	hit_box.process_mode = Node.PROCESS_MODE_INHERIT

func _on_animation_finished():
	if animation.animation == "hurt": #depois de terminar a animação de dano,chama o estado idle
		change_state(State.idle)

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
