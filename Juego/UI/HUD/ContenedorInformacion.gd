class_name ContenedorInformacion
extends NinePatchRect

## Atributos Export
export var auto_ocultar: bool = true setget set_auto_ocultar

## Atributos Onready
onready var texto_contenedor: Label = $Label
onready var auto_ocultar_timer: Timer = $AutoOcultarTimer
onready var animaciones: AnimationPlayer = $AnimationPlayer

## Atributos
var esta_activo: bool = true setget set_esta_activo

## Setters Y Getters
func set_auto_ocultar(puede:bool) -> void:
	auto_ocultar = puede

func set_esta_activo(valor: bool) -> void:
	esta_activo = valor

## Métodos
func mostrar() -> void:
	if esta_activo:
		animaciones.play("mostrar")

func ocultar() -> void:
	if not esta_activo:
		animaciones.stop()
	animaciones.play("ocultar")

func mostrar_suavizado() -> void:
	if not esta_activo:
		return
	animaciones.play("mostrar_suavizado")
	if auto_ocultar:
		auto_ocultar_timer.start()

func ocultar_suavizado() -> void:
	if esta_activo:
		animaciones.play("ocultar_suavizado")

func modificar_texto(text: String) -> void:
	texto_contenedor.text = text

## Señales Internas
func _on_AutoOcultarTimer_timeout() -> void:
	ocultar_suavizado()
