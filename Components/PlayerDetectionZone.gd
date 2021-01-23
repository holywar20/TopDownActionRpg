extends Area2D


var player = null

func _ready():
	pass

func canSeePlayer():
	return player != null

func _on_Area2D_body_entered(body):
	print("entering")
	player = body

func _on_Area2D_body_exited(body):
	print("exiting")
	player = null
