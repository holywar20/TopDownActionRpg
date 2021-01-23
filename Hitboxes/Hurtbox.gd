extends Area2D

onready var timer : Timer = $Timer
onready var collision : CollisionShape2D = $Collision

const HitEffect = preload("res://Hitboxes/HitEffect.tscn")

export(bool) var showHit = true 

func setInvincible(value: bool) -> void:
	set_deferred("monitoring" , !value)

func createHitEffect() -> void:
	var effect = HitEffect.instance()
	var world = get_tree().current_scene
	world.add_child(effect)
	effect.global_position = global_position

func startInvincibility(duration):
	setInvincible(true)
	timer.start(duration)

func _on_Timer_timeout():
	setInvincible(false)
