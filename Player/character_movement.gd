extends CharacterBody2D

@export var jump_force: int
@export var gravity: float
@export var speed: int

func _input(event):
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = -speed
	

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
	
	
	if Input.is_action_pressed("right"):
		position.x += speed * delta
		
	if Input.is_action_pressed("left"):
		position.x -= speed * delta

	move_and_slide()
