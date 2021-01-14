extends KinematicBody2D

const ACCELERATION = 600
const MAX_SPEED = 180
const FRICTION = 600

enum {
	MOVE, ROLL, ATTACK
}


# Animiation Tree properties
const BLEND_IDLE = "parameters/IDLE/blend_position"
const BLEND_RUN = "parameters/RUN/blend_position"
const BLEND_ATTACK = "parameters/ATTACK/blend_position"

onready var animationTree : AnimationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var state = MOVE
var velocity : Vector2 = Vector2.ZERO

func _ready():
	animationTree.active = true
	animationState.start("IDLE")

func _process( delta ):
	match state:
		MOVE:
			moveState( delta )
		ROLL:
			pass
		ATTACK:
			attackState( delta )

func attackState( delta ):
	animationState.travel("ATTACK")

func moveState( delta ):
	var inputVector : Vector2 = Vector2.ZERO
	
	inputVector.x = Input.get_action_strength("MOVE_RIGHT") - Input.get_action_strength("MOVE_LEFT")
	inputVector.y = Input.get_action_strength("MOVE_DOWN") - Input.get_action_strength("MOVE_UP")
	
	inputVector = inputVector.normalized()

	if( inputVector != Vector2.ZERO ):
		animationTree.set( BLEND_IDLE , inputVector )
		animationTree.set( BLEND_RUN , inputVector )
		animationTree.set( BLEND_ATTACK, inputVector )

		animationState.travel( "RUN" )

		velocity += inputVector * ACCELERATION * delta
		velocity = velocity.clamped( MAX_SPEED )
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta )
		animationState.travel( "IDLE" )
	
	velocity = move_and_slide( velocity )

	if Input.is_action_just_pressed("ATTACK"):
		state = ATTACK

func attackFinished():
	state = MOVE
