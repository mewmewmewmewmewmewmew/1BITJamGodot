extends Node2D
var offset = 75

@onready var follow_point = $CharacterBody2D
@onready var this = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	this.position = (Vector2i(this.position.x,follow_point.position.y-offset))
