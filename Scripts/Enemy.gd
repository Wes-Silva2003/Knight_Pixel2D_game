extends CharacterBody2D

enum State {WALK, ATTACK, DEATH}

const SPEED = 20.0

var state: State = State.WALK
var direction = 1

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $hitbox
@onready var hitbox_shape: CollisionShape2D = $hitbox/CollisionShape2D
@onready var player_detection: RayCast2D = $PlayerDetection
@onready var wall_collision: RayCast2D = $Collisions/WallCollision
@onready var terrain_collision: RayCast2D = $Collisions/terrainCollision

func _ready():
	animation.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	# Máquina de Estados
	match state:
		State.WALK:
			walk_logic(delta)
		State.ATTACK:
			attack_logic(delta)
		State.DEATH:
			death_logic(delta)
	
	move_and_slide()

# Controle de estados e animações
func change_state(new_state: State):
	if state == new_state:
		return
		
	state = new_state
	
	match state:
		State.WALK:
			animation.play("walk")
		State.ATTACK:
			animation.play("attack")
		State.DEATH:
			animation.play("death")

# Lógica de estados 
func walk_logic(_delta):
	velocity.x = SPEED * direction
	
	if wall_collision.is_colliding() or not terrain_collision.is_colliding():
		flip_direction()
	
	if player_detection.is_colliding():
		change_state(State.ATTACK)
	else:
		change_state(State.WALK)

func attack_logic(_delta):
	velocity.x = 0

func death_logic(_delta):
	velocity.x = 0
	disable_hitbox()

# Funções gerais
func flip_direction():
	direction *= -1
	scale.x *= -1

func take_damage():
	if state == State.DEATH:
		return
	change_state(State.DEATH)

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func disable_hitbox():
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED

func _on_animation_finished():
	match state:
		State.ATTACK:
			change_state(State.WALK)
