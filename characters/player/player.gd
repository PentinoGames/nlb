extends Area2D

@export var speed = 350 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var is_attacking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	var total_frames_attack =$AnimatedSprite2D.get_sprite_frames().get_frame_count("attack")
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		
	if Input.is_action_pressed("attack"):
		is_attacking = true
		$AnimatedSprite2D.play("attack",1.5)
		
	if is_attacking:
		attack(total_frames_attack)
		
	if !is_attacking:
		if velocity.length() > 0 :
			velocity = velocity.normalized() * speed
			walk(velocity)
		else:
			if velocity.length()==0:
				idle()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
func idle():
	$AnimatedSprite2D.play("idle")
	
func walk(velocity):
	$AnimatedSprite2D.flip_v = false
	$AnimatedSprite2D.flip_h = velocity.x < 0
	$AnimatedSprite2D.play("walk")
	
func attack(total_frames_attack):
	if ($AnimatedSprite2D.get_frame()+1) >= total_frames_attack :
		$AnimatedSprite2D.stop()
		is_attacking=false
