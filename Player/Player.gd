extends KinematicBody2D

const ACCELERATION = 600
const MAX_SPEED = 180
const FRICTION = 600

# Animiation Tree properties
const IDLE = "parameters/IDLE/blend_position"
const RUN = "parameters/RUN/blend_position"

onready var animationTree : AnimationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var velocity : Vector2 = Vector2.ZERO

func _ready():
	animationState.start("IDLE")

func _physics_process(delta):
	
	var inputVector : Vector2 = Vector2.ZERO
	
	inputVector.x = Input.get_action_strength("MOVE_RIGHT") - Input.get_action_strength("MOVE_LEFT")
	inputVector.y = Input.get_action_strength("MOVE_DOWN") - Input.get_action_strength("MOVE_UP")
	
	inputVector = inputVector.normalized()

	if( inputVector != Vector2.ZERO ):
		animationTree.set( IDLE , inputVector )
		animationTree.set( RUN , inputVector )

		animationState.travel( "RUN" )

		velocity += inputVector * ACCELERATION * delta
		velocity = velocity.clamped( MAX_SPEED )
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta )
		animationState.travel( "IDLE" )
	
	velocity = move_and_slide( velocity )
