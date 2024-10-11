extends Node
@export var y_offset := 0
@onready var Transition = $Transition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Transition.play("FADEIN")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Camera2D.global_position = Vector2($Camera2D.global_position.x, $player.global_position.y + y_offset)
	Transition.global_position = Vector2($Camera2D.global_position.x, $player.global_position.y + y_offset)
func play_fade():
	Transition.play("FADEIN")


func play_fade_reverse():
	Transition.play("FADEEOUT")


func _on_player_fade_out() -> void:
	print("I was called")
	$Transition/DeathText.visible = true
	Transition.play("FADEEOUT")
