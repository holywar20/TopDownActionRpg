extends Node

export(int) var maxHealth = 1
var health : int = 1 setget setHealth

signal no_health
signal health_changed
signal max_health_changed

func _ready():
	health = maxHealth

func setHealth( value : int ) -> void:
	emit_signal("health_changed" , value)
	health = value
	if health <= 0:
		emit_signal("no_health")
