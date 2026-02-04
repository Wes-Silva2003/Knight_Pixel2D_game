extends Node

#caminho do arquivo de save
const SAVE_PATH = "user://savegame.save"

#variaveis de pontos e vidas
var lifes: int = 3
var points: int = 0
var record: int = 0

#lista que guarda todas as moedas e inimigos já 'usados' ou 'mortos'
var collected_items: Array = [] 
var load_position: Vector2 = Vector2.ZERO
var has_load_position: bool = false
var player_ref: CharacterBody2D = null

#sinais
@warning_ignore("unused_signal")
signal colect_bronze
@warning_ignore("unused_signal")
signal colect_silver
@warning_ignore("unused_signal")
signal colect_gold
@warning_ignore("unused_signal")
signal extra_life
@warning_ignore("unused_signal")
signal state_win
@warning_ignore("unused_signal")
signal pause_game
signal data_loaded

func _add_points(value):
	points += value

func _update_record():
	if record < points:
		record = points

# Função auxiliar para limpar tudo
func _reset_all_data():
	_reset_points()
	_reset_lifes()
	collected_items.clear()
	has_load_position = false #esquece a posição salva anterior

func _reset_points():
	points = 0
	collected_items.clear()
	has_load_position = false

func _reset_lifes():
	lifes = 3
	collected_items.clear()
	has_load_position = false

func save_game_scene(path_scene: String):
	get_tree().change_scene_to_file(path_scene)#inicia a troca de cena
	await get_tree().create_timer(0.3).timeout #espera um fração de segundo para a nova cena carregar 
	player_ref = null #limpa a referência do "Player" antigo para forçar o save a achar o novo
	save_game() #ele vai salvar a posição inicial da nova fase

#sistema de save e load
func save_game():
	# tenta encontrar o "player" caso a referência tenha se perdido
	if player_ref == null:
		player_ref = get_tree().get_first_node_in_group("Player")
	
	#se não a achar o "player" ele retorna e impede o salvamento para não dar erro no jogo
	if player_ref == null: 
		return

	var data = { #tranforma tudo importante em variavel 
		"scene": get_tree().current_scene.scene_file_path, #cena atual
		"pos_x": player_ref.global_position.x, #posição do player
		"pos_y": player_ref.global_position.y, #posição do player
		"saved_lifes": lifes, #vidas
		"saved_points": points, #pontos
		"collected_items": collected_items #moedas coletadas e inimigos mortos
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE) #abre o arquivo de save, apaga tudo e salva novamente os novos dados
	if file:
		file.store_string(JSON.stringify(data)) #converte o arquivo para jason e escreve no arquivo

func load_game():
	if not FileAccess.file_exists(SAVE_PATH): #verifica se existe o arquivo 
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ) #abre e lê o arquivo
	var json = JSON.new()
	var finish = json.parse(file.get_as_text()) #tenta converter o arquivo de texto em dados novamente
	
	if finish == OK: # se o arquivo estiver "ok" ele avança
		var data = json.get_data()
		
		# Se o dado não existir no arquivo, usa o valor padrão (3 e 0)
		lifes = data.get("saved_lifes", 3) #3 para a vida
		points = data.get("saved_points", 0) #0 para os pontos
		
		if data.has("collected_items"): #verifica se existe a array de itens
			collected_items = data["collected_items"] #se existir carrega no jogo
		else:
			collected_items = [] #se não existir, inicie uma lista vazia e impede erros de load
			
		load_position = Vector2(data.get("pos_x", 0), data.get("pos_y", 0)) #carrega o player na posição correta (x,y salvos separadamente)
		has_load_position = true
		
		# Carrega a cena
		if data.has("scene"):
			get_tree().change_scene_to_file(data["scene"])
			emit_signal("data_loaded")
