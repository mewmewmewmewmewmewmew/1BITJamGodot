extends TextureRect


func play_fade():
	$AnimationPlayer.play("fade")


func play_fade_reverse():
	$AnimationPlayer.play_backwards("fade")
