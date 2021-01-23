extends KinematicBody2D

var DeathEffect = preload("res://Enemies/Bat/DeathEffect.tscn")

const KNOCKBACK_AMOUNT : int  = 150
enum { IDLE, WANDER, CHASE }

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

onready var batStats : Node = $Stats
onready var playerDetector : Area2D = $PlayerDector
onready var sprite : AnimatedSprite = $Sprite

# physics related vars 
var knockBack : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO 
var state : int

func _physics_process(delta):
	knockBack = knockBack.move_toward(Vector2.ZERO , 200 * delta)
	knockBack = move_and_slide(knockBack)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO , 200 * delta)
			seekPlayer()
		WANDER:
			pass
		CHASE:
			if( playerDetector.canSeePlayer() ):
				var player = playerDetector.player
				var dir = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(dir * MAX_SPEED , ACCELERATION * delta)
				sprite.flip_h = velocity.x < 0
			else:
				state = IDLE
	
	
	velocity = move_and_slide(velocity)

func seekPlayer():
	if playerDetector.canSeePlayer():
		state = CHASE


# Signals
# 'calling down'. Call methods below you in scene tree from scene root directly.
func _on_HurtBox_area_entered( area: Area2D ):
	batStats.health -= 1
	knockBack = KNOCKBACK_AMOUNT * area.directionVector

# Subscribe to things below you using sigals. Things below you in tree should tell you about them using signals
func _on_Stats_no_health():
	var effect : AnimatedSprite = DeathEffect.instance()
	get_parent().add_child(effect)
	effect.global_position = global_position
	queue_free()
