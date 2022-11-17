extends Node

## Atributos Export
export var tiempo_transicion: float = 4.0
export(float, -50.0, -20.0, 5.0 ) var volumen_apagado = -40

## Atributos Onready
onready var lista_musicas: Dictionary = {
	"menu_principal": $MusicaMenuPrincipal,
	"musica_nivel": $MusicaNivel,
	"musica_meteoritos": $MusicaMeteoritos,
	"musica_interceptores": $MusicaInterceptores,
	"musica_orbitales": $MusicaOrbitales,
	} setget ,get_lista_musicas

onready var tween_on: Tween = $TweenMusicaOn
onready var tween_off: Tween = $TweenMusicaOff

## Atributos
var vol_original_musica_off: float = 0.0

## Métodos
func get_lista_musicas() -> Dictionary:
	return lista_musicas

## Métodos Custom
#func set_streams(stream_musica: AudioStream, stream_meteoritos: AudioStream, stream_interceptores: AudioStream, stream_orbitales: AudioStream) -> void:
#	musica_nivel.stream = stream_musica
#	musica_meteoritos.stream = stream_meteoritos
#	musica_interceptores.stream = stream_interceptores
#	musica_orbitales.stream = stream_orbitales

func play_musica(musica: AudioStreamPlayer) -> void:
	stop_todo()
	musica.play()

func play_musica_nivel() -> void:
	stop_todo()
	play_musica(get_lista_musicas().musica_nivel)

func stop_todo() -> void:
	for nodo in get_children():
		if nodo is AudioStreamPlayer:
			nodo.stop()

func play_boton() -> void:
	$BotonMenu.play()

#func transicion_musicas() -> void:
#	if musica_nivel.playing:
#		fade_in(musica_interceptores)
#		fade_out(musica_nivel)
#	else:
#		fade_in(musica_nivel)
#		fade_out(musica_interceptores)


func fade_in(musica_fade_in: AudioStreamPlayer) -> void:
	var volumen_original = musica_fade_in.volume_db
	musica_fade_in.volume_db = volumen_apagado
	musica_fade_in.play()
	tween_on.interpolate_property(
		musica_fade_in,
		"volume_db",
		volumen_apagado,
		volumen_original,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	
	tween_on.start()


func fade_out(musica_fade_out: AudioStreamPlayer) -> void:
	vol_original_musica_off = musica_fade_out.volume_db
	tween_off.interpolate_property(
		musica_fade_out,
		"volume_db",
		musica_fade_out.volume_db,
		volumen_apagado,
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	
	tween_off.start()


## Señales Internas
func _on_TweenMusicaOff_tween_completed(object: Object, key: NodePath) -> void:
	object.stop()
	object.volume_db = vol_original_musica_off
