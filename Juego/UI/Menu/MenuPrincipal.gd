extends Node

export(String, FILE, "*.tscn") var nivel_inicial = ""

## Métodos
func _ready() -> void:
	OS.set_window_fullscreen(true)
	MusicaJuego.play_musica(MusicaJuego.get_lista_musicas().menu_principal)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Entrar"):
		get_tree().change_scene(nivel_inicial)
	if event.is_action_pressed("Salir"):
		get_tree().quit()

## Señales Internas
func _on_BotonJugar_pressed() -> void:
	MusicaJuego.play_boton()
	get_tree().change_scene(nivel_inicial)

func _on_BotonSalir_pressed() -> void:
	MusicaJuego.play_boton()
	get_tree().quit()
	
