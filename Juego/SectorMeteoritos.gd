class_name SectorMeteoritos
extends Node2D

## Atributos Export
export var cantidad_meteoritos:int = 10
export var intervalo_spawn:float = 1.2

## Atributos Onready
onready var advertencia:AnimationPlayer = $AnimationPlayer

## Atributos
var spawners:Array

## Métodos
func _ready() -> void:
	almacenar_spawners()
	conectar_seniales_detectores()
	advertencia.play("advertencia")
	$SpawnTimer.wait_time = intervalo_spawn

## Metodos Custom
func almacenar_spawners() -> void:
	for spawner in $Spawners.get_children():
		spawners.append(spawner)

func spawner_aleatorio() -> int:
	randomize()
	return randi() % spawners.size()
	
func conectar_seniales_detectores() -> void:
	for detector in $DetectorFuerzaZona.get_children():
		detector.connect("body_entered", self, "_on_detector_body_entered")

## Constructor
func crear(pos:Vector2, meteoritos:int) -> void:
	global_position = pos
	cantidad_meteoritos = meteoritos 

## Senales Internas
func _on_SpawnTimer_timeout() -> void:
	if cantidad_meteoritos == 0:
		$SpawnTimer.stop()
		return

	spawners[spawner_aleatorio()].spawnear_meteorito()
	cantidad_meteoritos -= 1 


func _on_detector_body_entered(body: Node) -> void:
	body.set_esta_en_sector(false)
