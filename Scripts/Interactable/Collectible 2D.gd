extends StaticBody3D

@export var item: InventoryItem:
	set(new_value):
		item = new_value
		$Sprite3D.texture = item.icon
		$Sprite3D.texture_changed
	get:
		return item
var player = null

func _on_interactable_area_body_entered(body):
	if body.has_method("player"):
		player = body
		playercollect()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()
		
func playercollect():
	player.collect(item)

func _on_area_3d_body_entered(body):
	if body.has_method("player"):
		player = body
		playercollect()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()
