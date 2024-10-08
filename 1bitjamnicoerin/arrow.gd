extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_visible(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_show_arrow(pos: Variant, rot: Variant) -> void:
	set_visible(true)
	position = pos
	rotation = rot

func _on_hide_arrow() -> void:
	set_visible(false)
