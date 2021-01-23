extends KinematicBody2D

const ACCELERATION = 600
const MAX_SPEED = 180
const ROLL_SPEED = 240
const FRICTION = 600

enum {
	MOVE, ROLL, ATTACK
}


# Animiation Tree properties
const BLEND_IDLE = "parameters/IDLE/blend_position"
const BLEND_RUN = "parameters/RUN/blend_position"
const BLEND_ATTACK = "parameters/ATTACK/blend_position"
const BLEND_ROLL = "parameters/ROLL/blend_position"

var stats = PlayerStats

onready var animationTree : AnimationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox : Area2D = $Position2D/Sword
onready var hurtBox : Area2D = $HurtBox

var state = MOVE
var velocity : Vector2 = Vector2.ZERO
var rollVector : Vector2 = Vector2.DOWN

func _ready():
	stats.connect("no_health", self , "queue_free")
	animationTree.active = true
	animationState.start("IDLE")
	swordHitbox.directionVector = rollVector

# Using process instead of _physics_process, since we don't need direct physics vars
func _physics_process( delta ):
	match state:
		MOVE:
			moveState( delta )
		ROLL:
			rollState( delta )
		ATTACK:
			attackState( delta )

#states
func attackState( delta ):
	animationState.travel("ATTACK")

func rollState( delta ):
	velocity = rollVector * ROLL_SPEED
	animationState.travel("ROLL")
	velocity = move_and_slide( velocity )

func moveState( delta ):
	var inputVector : Vector2 = Vector2.ZERO
	
	inputVector.x = Input.get_action_strength("MOVE_RIGHT") - Input.get_action_strength("MOVE_LEFT")
	inputVector.y = Input.get_action_strength("MOVE_DOWN") - Input.get_action_strength("MOVE_UP")
	
	inputVector = inputVector.normalized()

	if( inputVector != Vector2.ZERO ):
		rollVector = inputVector
		swordHitbox.directionVector = rollVector
		animationTree.set( BLEND_IDLE , inputVector )
		animationTree.set( BLEND_RUN , inputVector )
		animationTree.set( BLEND_ATTACK, inputVector )
		animationTree.set( BLEND_ROLL , inputVector )

		animationState.travel( "RUN" )

		velocity += inputVector * ACCELERATION * delta
		velocity = velocity.clamped( MAX_SPEED )
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta )
		animationState.travel( "IDLE" )
	
	velocity = move_and_slide( velocity )

	if Input.is_action_just_pressed("ROLL"):
		state = ROLL

	if Input.is_action_just_pressed("ATTACK"):
		state = ATTACK

# State transitions
func rollFinished():
	state = MOVE

func attackFinished():
	state = MOVE

# Respond to these signals
func _on_HurtBox_area_entered(area):
	stats.health -= 1
	hurtBox.createHitEffect()
	hurtBox.startInvincibility(0.5)
