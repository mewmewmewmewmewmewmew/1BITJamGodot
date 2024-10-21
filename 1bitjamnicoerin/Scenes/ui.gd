extends CanvasLayer

@onready var transition = $Control/Transition

func play_fade():
	transition.play("FADEIN")


func play_fade_reverse():
	transition.play("FADEOUT")


func play_death_screen_transition():
	$Control/Transition/DeathText.visible = true
	play_fade_reverse()
