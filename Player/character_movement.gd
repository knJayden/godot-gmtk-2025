extends CharacterBody2D

@export var jump_force: int
@export var gravity: float
@export var acceleration: int
@export var friction: float

func _input(event):
	if event.is_action_pressed("jump") and is_on_floor():
		print("jump")
		velocity.y = -jump_force

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	# Handle input
	if Input.is_action_pressed("right"):
		velocity.x += acceleration * delta
		
	if Input.is_action_pressed("left"):
		velocity.x -= acceleration * delta

	move_and_slide()

func _on_hit_box_area_entered(area):
	if area is HurtBox:
		var vector = position - area.position
		velocity = -(vector * 1)
