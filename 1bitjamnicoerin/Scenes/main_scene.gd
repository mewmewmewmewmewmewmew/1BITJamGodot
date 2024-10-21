extends Node2D

@onready var player_scene: PackedScene = preload("res://Resources/player.tscn")
@onready var terrain_gen = $NewTerrainGen
@onready var ui = $UI

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.ui = ui
	Globals.fmod_basics = $"FMOD BASIC"
	Globals.terrain = terrain_gen
	
	Globals.fmod_basics.get_node("Music").play()
	ui.play_fade()
	
	player = player_scene.instantiate()
	Globals.player = player
	player.fade_out.connect(_on_player_death)
	
	terrain_gen.generate_terrain()
	terrain_gen.place_player(player)

func _on_player_death():
	ui.play_death_screen_transition()
	Globals.fmod_basics.get_node("Die").play()
	Globals.fmod_basics.get_node("DieMusic").play()
	Globals.fmod_basics.get_node("Music").stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
