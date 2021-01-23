extends Sprite

const GrassEffect = preload("res://World/Grass/GrassDestroyed.tscn")

func _on_Node2D_area_shape_entered(area_id, area, area_shape, self_shape):
	var effect : AnimatedSprite = GrassEffect.instance()
	get_parent().add_child(effect)
	effect.global_position = global_position
	queue_free()
