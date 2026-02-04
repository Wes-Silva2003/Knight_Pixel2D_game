extends CharacterBody2D

#estados dos inimigos
enum State {WALK, ATTACK, DEATH}

const SPEED: float = 25.0

var state: State = State.WALK
var direction: int = 1

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $hitbox
@onready var hitbox_shape: CollisionShape2D = $hitbox/CollisionShape2D
@onready var player_detection: RayCast2D = $PlayerDetection
@onready var wall_collision: RayCast2D = $Collisions/WallCollision
@onready var terrain_collision: RayCast2D = $Collisions/terrainCollision
@onready var death_audio: AudioStreamPlayer2D = $death
@onready var attack_audio: AudioStreamPlayer2D = $attack

func _ready():
	if str(get_path()) in GameManager.collected_items: #se coletado ou morto é apagado (coloquei como coletado para salvar em caso de load)
		queue_free()
	animation.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	# Máquina de logica dos estados
	match state:
		State.WALK:
			walk_logic(delta)
		State.ATTACK:
			attack_logic(delta)
		State.DEATH:
			death_logic(delta)
	
	move_and_slide()

# Controle de estados para as animações e audio
func change_state(new_state: State):
	if state == new_state:
		return
		
	state = new_state
	
	match state:
		State.WALK:
			animation.play("walk")
		State.ATTACK:
			animation.play("attack")
			attack_audio.play()
		State.DEATH:
			animation.play("death")
			death_audio.play()

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
	change_state(State.DEATH)
	GameManager._add_points(5)

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func disable_hitbox():
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED

func _on_animation_finished(): #espera terminar a animação de attack para voltar a andar
	match state:
		State.ATTACK:
			change_state(State.WALK)
		State.DEATH:
			GameManager.collected_items.append(str(get_path()))
			#queue_free() 
		# está comentado pois depois de mortos ele são apagado, porem achei melhor ficarem lá mortos e só serem apagados em caso de load
