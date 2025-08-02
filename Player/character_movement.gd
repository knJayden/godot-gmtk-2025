extends CharacterBody2D

@export var jump_force: int
@export var gravity: float
@export var acceleration: int
@export var friction: float
@export var max_move_velocity: float

@export var bubble_duration: float
 
var bubble_cooldown_timer: Timer

var bubble_duration_timer: Timer


var bubble_on_cooldown: bool = false

var bubble_active: bool = false

var bubble_sprite: Sprite2D

func _ready():
	bubble_cooldown_timer = $BubbleCooldown
	bubble_duration_timer = $BubbleDuration
	bubble_sprite = $BubbleSprite


func _input(event):
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	
	if event.is_action_pressed("bubble") and !bubble_on_cooldown:
		print("Activate bubble")
		bubble_sprite.visible = true
		bubble_active = true
		bubble_on_cooldown = true
		bubble_duration_timer.start(bubble_duration)

	
func _physics_process(delta):
	
	apply_gravity(delta)
	
	var is_input = Input.is_action_pressed("right") or Input.is_action_pressed("left")
		
	if is_on_floor() and !is_input:
		velocity.x = move_toward(velocity.x, 0, friction * delta)


	if Input.is_action_pressed("right"):
		velocity.x += acceleration * delta
		
	if Input.is_action_pressed("left"):
		velocity.x -= acceleration * delta
	
	
	if abs(velocity.x) > max_move_velocity:
		velocity.x = max_move_velocity
	
	move_and_slide()

func _on_hit_box_area_entered(area):
	if area is HurtBox:
		if bubble_active:
			var collision_normal = (global_position - area.global_position).normalized()

			var min_bounce_strength = 400
			var current_speed = velocity.length()
			var bounce_speed = max(current_speed, min_bounce_strength)

			velocity = velocity.bounce(collision_normal).normalized() * bounce_speed



		else:
			print("Dead")


func apply_gravity(delta: float):
	if !is_on_floor():
		velocity.y += gravity




func _on_bubble_duration_timeout():
	print("Bubble over")
	bubble_sprite.visible = false

	bubble_active = false
	bubble_cooldown_timer.start(2)


func _on_bubble_cooldown_timeout():
	print("Bubble ready")
	bubble_on_cooldown = false
