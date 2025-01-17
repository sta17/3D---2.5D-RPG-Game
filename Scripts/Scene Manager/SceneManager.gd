extends Node3D

var next_scene = null
var spawn_point = null
@onready var current_scene_holder:Node3D = $CurrentScene
@onready var player = $Player

func _ready():
	$"Fade to Black/NinePatchRect".visible = false

func transition_to_scene(new_scene:String,goto_point:String=""):
	next_scene = new_scene
	spawn_point = goto_point
	
	#$"Fade to Black/AnimationPlayer".play("FadeToBlack")
	#transition_to_sceneWithOutFade(new_scene,goto_point)
	finished_fading()
	
func finished_fading():
	# turn player off to prevent triggering things.
	player.stop_inputs()
	player.set_process(false)
	player.set_process_input(false)
	get_tree().paused = true
	current_scene_holder.set_block_signals(true)
	
	# Change transition code here.
	var localSceneHandler = current_scene_holder.get_child(0)
	localSceneHandler.queue_free()

	var scene = load(next_scene).instantiate()
	
	var area_Name:String = scene.Area_Display_Name[spawn_point]
	area_Name = "  " + area_Name
	$"Fade to Black/NinePatchRect/Panel/Label".text = area_Name
	
	# Set Player Location in scene,
	var player_spawn_point:Vector3 = scene.get_spawn_point(spawn_point)
	player.set_location(player_spawn_point)
	
	# turn player on again.
	player.set_process(true)
	player.set_process_input(true)
	get_tree().paused = false
	player.start_inputs()
	current_scene_holder.set_block_signals(false)
	
	current_scene_holder.add_child(scene)
	
	#$"Fade to Black/AnimationPlayer".play("FadeToNormal")
	displayAreaName()

func displayAreaName():
	$"Fade to Black/AnimationPlayer".play("Show Sign")

func transition_to_sceneWithOutFade(new_scene:String,goto_point:String=""):
	next_scene = new_scene
	spawn_point = goto_point
	
	# turn player off to prevent triggering things.
	player.stop_inputs()
	player.set_process(false)
	player.set_process_input(false)
	get_tree().paused = true
	current_scene_holder.set_block_signals(true)
	
	# Change transition code here.
	var localSceneHandler = current_scene_holder.get_child(0)
	localSceneHandler.queue_free()

	var scene = load(next_scene).instantiate()
	scene.set_block_signals(true)
	
	# Set Player Location in scene,
	var player_spawn_point:Vector3 = scene.get_spawn_point(spawn_point)
	player.set_location(player_spawn_point)
	
	# turn player on again.
	player.set_process(true)
	player.set_process_input(true)
	get_tree().paused = false
	player.start_inputs()
	current_scene_holder.set_block_signals(false)
	scene.set_block_signals(false)
	
	current_scene_holder.add_child(scene)
