extends Node3D

func _ready():
	$SceneManager.transition_to_sceneWithOutFade("res://Scenes/Areas/Test Stage 2.tscn","Start")
