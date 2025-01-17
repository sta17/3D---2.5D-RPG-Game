extends Node3D

@export var spawn_points:Dictionary
@export var Area_Display_Name:Dictionary

func get_spawn_point(spawn_point_key:String="")-> Vector3:
	if spawn_points.size() == 1:
		return spawn_points[spawn_points.keys()[0]]
	else:
		return spawn_points[spawn_point_key]
