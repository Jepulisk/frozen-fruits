extends KinematicBody2D

var velocity = Vector2()

var x = 0
var y = 0

export var acceleration = 100
export var speed = 250

onready var bounceTimer = $bounceTimer

func _ready():
	y = -1

func _physics_process(delta):
	var direction = Vector2();
	
	if bounceTimer.is_stopped():
		x = 0
		if Input.is_action_pressed("right"): x = 1
		if Input.is_action_pressed("left"): x = -1
	
	if is_on_wall(): 
		bounceTimer.start()
		if x == 1: x = -1
		else: x = 1
	
	if is_on_ceiling(): 
		y = 1
	if is_on_floor(): 
		y = -1
	
	direction.x = x
	direction.y = y
	
	velocity = lerp(velocity, direction * speed, acceleration * delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	for index in get_slide_count():
			var collider = get_slide_collision(index).collider
			if collider.is_in_group("yellow"):
				if collider.is_in_group("fruit"): collider.die()
				if collider.is_in_group("bomb"):
					collider.die()
					die()

func die():
	visible = false
	set_physics_process(false)
