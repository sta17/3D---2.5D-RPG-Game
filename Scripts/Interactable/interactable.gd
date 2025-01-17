extends StaticBody3D

#@export var localinventory : Inv
var player = null

func _on_interact_area_body_entered(body):
	if body.has_method("player"):
		player = body
		OpenChest()

func _on_interact_area_body_exited(body):
	if body.has_method("player"):
		EndOpenChest()
		player = null

func OpenChest():
	player.inventoryInteraction()
	
func EndOpenChest():
	player.inventoryInteractionEnd()
