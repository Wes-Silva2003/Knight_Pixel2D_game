@tool #torna visivel no editor 
extends Area2D

#torna possivel exportar o arquivo contendo os valores do coletavel
@export var data: ItemData:
	set(value):
		data = value
		_update_visuals()

#verifica se o item foi coletado
var is_collected: bool = false 

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready():
	_update_visuals()
	
	if not Engine.is_editor_hint(): #separa o modo de construção do modo de jogo
		if str(get_path()) in GameManager.collected_items: #verifica se o item já foi coletado
			queue_free() #apaga

#carrega a animação do coletavel
func _update_visuals():
	if animated_sprite and data and data.animation_frames:
		animated_sprite.sprite_frames = data.animation_frames
		animated_sprite.play("default")

func _on_body_entered(body):
	if Engine.is_editor_hint(): return #evita que o jogador pegue coletavel no editor
	
	if is_collected: #se coletada ignore
		return

	if body.is_in_group("Player"): #se não coletada verifica se foi o player e coleta
		collect_item()

#coleta de item
func collect_item():
	is_collected = true 
	GameManager.collected_items.append(str(get_path()))
	
	if data: #dependendo da moeda emite o sinal correspondente
		if data.item_type == "Coin":
			GameManager._add_points(data.value)
			if data.value == 1: GameManager.colect_bronze.emit()
			elif data.value == 5: GameManager.colect_silver.emit()
			elif data.value == 10: GameManager.colect_gold.emit()
			
		#se for vida emite o sinal de vida extra
		elif data.item_type == "Life":
			GameManager.lifes += data.value
			GameManager.extra_life.emit()

		# Som
		if data.sound_effect:
			audio_player.stream = data.sound_effect
			audio_player.play()
			
		#torna invisivel e impossivel de colidir imediatamente e depois apagar
			visible = false
			if animated_sprite: animated_sprite.visible = false
			collision.set_deferred("disabled", true)
			
			await audio_player.finished
			queue_free()
		else:
			queue_free()
	else:
		queue_free()
