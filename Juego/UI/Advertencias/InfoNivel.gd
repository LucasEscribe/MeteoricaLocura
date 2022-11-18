extends CanvasLayer

## Atributos Onready
onready var advertencia:AnimationPlayer = $AnimationPlayer

## Mëtodos
func _ready() -> void:
	advertencia.play("swpawn")
