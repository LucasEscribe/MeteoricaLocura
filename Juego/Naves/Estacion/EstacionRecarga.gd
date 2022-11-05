class_name EstacionRecarga
extends Node2D

## atributos Onready
onready var carga_sfx:AudioStreamPlayer2D = $CargaSFX
onready var vacio_sfx: AudioStreamPlayer2D = $VacioSFX

## Atributos Export
export var energia:float = 6.0
export var radio_energia_entregada: float = 0.5

## Atributos
var nave_player: Player = null
var player_en_zona: bool = false

## Metodos
func _unhandled_input(event: InputEvent) -> void:
	if not puede_recargar(event):
		return
	
	controlar_energia()

	if event.is_action("recargar_escudo"):
		nave_player.get_escudo().controlar_energia(radio_energia_entregada)
	elif event.is_action("recargar_laser"):
		nave_player.get_laser().controlar_energia(radio_energia_entregada)

## Métodos Custom
func puede_recargar(event: InputEvent) -> bool:
	var hay_input = event.is_action("recargar_escudo") or event.is_action("recargar_laser")
	if hay_input and player_en_zona and energia > 0.0:
		if !carga_sfx.playing:
			carga_sfx.play()
		return true
	
	return false

func controlar_energia() -> void:
	energia -= radio_energia_entregada
	print("Energía Estación: ", energia)
	if energia <= 0.0:
		vacio_sfx.play()
		carga_sfx.stop()


## Señales Internas
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()

func _on_AreaRecarga_body_entered(body: Node) -> void:
	if body is Player:
		nave_player = body
		player_en_zona = true

	body.set_gravity_scale(0.1)

func _on_AreaRecarga_body_exited(body: Node) -> void:
	if body is Player:
		player_en_zona = false
		if vacio_sfx.playing or carga_sfx.playing:
			vacio_sfx.stop()
			carga_sfx.stop()

	body.set_gravity_scale(0.0)