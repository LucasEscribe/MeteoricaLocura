class_name BaseEnemiga
extends Node2D

## Atributos Export
export var hitpoints: float = 25.0
export var orbital: PackedScene = null
export var numero_orbitales: int = 7
export var intervalo_spawn: float = 1.0
export(Array, PackedScene) var rutas


## Atributos Onready
onready var impacto_sfx: AudioStreamPlayer2D = $ImpactoSFX
onready var timer_spawner: Timer = $TimerSpawnerEnemigos
onready var barra_salud: BarraSalud = $BarraSalud

## Atributos
var esta_destruida: bool = false
var posicion_spawn: Vector2 = Vector2.ZERO
var ruta_seleccionada:Path2D

## Métodos
func _ready() -> void:
	timer_spawner.wait_time = intervalo_spawn
	$AnimationPlayer.play(elegir_animacion_aleatoria())
	seleccionar_ruta()
	barra_salud.set_valores(hitpoints)

func elegir_animacion_aleatoria() -> String:
	randomize()
	var num_anim: int = $AnimationPlayer.get_animation_list().size() -1
	var indice_anim_aleatoria: int = randi() % num_anim + 1
	var lista_animacion: Array = $AnimationPlayer.get_animation_list()
	
	return lista_animacion[indice_anim_aleatoria]

func _process(delta: float) -> void:
	var player_objetivo: Player = DatosJuego.get_player_actual()
	if not player_objetivo:
		return
		
	var dir_player:Vector2 = player_objetivo.global_position - global_position
	var angulo_player: float = rad2deg(dir_player.angle())
	
## Métodos Custom
func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	
	if hitpoints <= 0 and not esta_destruida:
		esta_destruida = true
		destruir()
		MusicaJuego.fade_out(MusicaJuego.get_lista_musicas().musica_orbitales)
		MusicaJuego.play_musica_nivel()
	
	barra_salud.set_hitpoints_actual(hitpoints)
	impacto_sfx.play()

func destruir() -> void:
	var posicion_partes = [
		$Sprite/Sprite1.global_position,
		$Sprite/Sprite2.global_position,
		$Sprite/Sprite3.global_position,
		$Sprite/Sprite4.global_position
	]

	Eventos.emit_signal("base_destruida", self, posicion_partes)
	Eventos.emit_signal("minimapa_objeto_destruido", self)
	queue_free()

func spawnear_orbital() -> void:
	numero_orbitales -= 1
	ruta_seleccionada.global_position = global_position
	
	var new_orbital: EnemigoOrbital = orbital.instance()
	new_orbital.crear(
		global_position + posicion_spawn,
		self,
		ruta_seleccionada
	)

	Eventos.emit_signal("spawn_orbital", new_orbital)

func deteccion_cuadrante() -> Vector2:
	var player_objetivo: Player = DatosJuego.get_player_actual()
	
	if not player_objetivo:
		return Vector2.ZERO
	
	var dir_player: Vector2 = player_objetivo.global_position - global_position
	var angulo_player: float = rad2deg(dir_player.angle())
	
	if abs(angulo_player) <= 45.0:
		#Player entra por derecha
		ruta_seleccionada.rotation_degrees = 180.0
		return $PosicionesSpawn/Este.position
	elif abs(angulo_player) > 135.0 and abs(angulo_player) <= 180.0:
		#Player entra izquierda
		ruta_seleccionada.rotation_degrees = 0.0
		return $PosicionesSpawn/Oeste.position
	elif abs(angulo_player) > 45.0 and abs(angulo_player) <= 135.0:
		#Player entra por arriha o por abajo
		if sign(angulo_player) > 0.0:
			#Player entra por abajo
			ruta_seleccionada.rotation_degrees = 270.0
			return $PosicionesSpawn/Sur.position
		else:
			#Player entra por arriba
			ruta_seleccionada.rotation_degrees = 90.0
			return $PosicionesSpawn/Norte.position
	
	return $PosicionesSpawn/Norte.position


func seleccionar_ruta() -> void:
	randomize()
	var indice_ruta: int = randi() % rutas.size() - 1
	ruta_seleccionada = rutas[indice_ruta].instance()
	add_child(ruta_seleccionada)



## Señales Internas
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	#Spawn Orbital
	if MusicaJuego.get_lista_musicas().musica_interceptores.playing:
		MusicaJuego.stop_todo()
	MusicaJuego.fade_out(MusicaJuego.get_lista_musicas().musica_nivel)
	MusicaJuego.fade_in(MusicaJuego.get_lista_musicas().musica_orbitales)
	$VisibilityNotifier2D.queue_free()
	posicion_spawn = deteccion_cuadrante()
	spawnear_orbital()
	timer_spawner.start()


func _on_TimerSpawnerEnemigos_timeout() -> void:
	if numero_orbitales == 0:
		timer_spawner.stop()
		return
	spawnear_orbital()
