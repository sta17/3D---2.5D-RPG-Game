extends Node3D

func _ready():
	$SceneManager.transition_to_sceneWithOutFade("res://Scenes/Areas/Test Stage 2.tscn","Start")
	#Give first creature.

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior
		# Later handle exit behavior
