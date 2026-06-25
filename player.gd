extends CharacterBody2D

var health = 100
var attack = 25
var sprint = 200
var speed = 200 
var screen_size 
var is_attacked = false
var is_attacking = false
var facing = "right"

func idle():
	# Jangan ganti ke idle kalau sedang di tengah-tengah animasi serangan
	if is_attacking:
		return
		
	if facing == "right":
		$PlayerSprites.animation = "idle_right"
	elif facing == "up":
		$PlayerSprites.animation = "idle_up"
	elif facing == "down":
		$PlayerSprites.animation = "idle_down"

func walk_RightLeft(velocity):
	facing = "right" # Simpan arah
	$PlayerSprites.animation = "walk_right"
	$PlayerSprites.flip_v = false
	$PlayerSprites.flip_h = velocity.x < 0
	
func walk_Up(velocity):
	facing = "up"
	$PlayerSprites.animation = "walk_up"
	$PlayerSprites.flip_v = false 
	
func walk_Down(velocity):
	facing = "down"
	$PlayerSprites.animation = "walk_down"
	$PlayerSprites.flip_v = false 
	
func sprint_RightLeft(velocity):
	facing = "right"
	$PlayerSprites.animation = "sprint_right"
	$PlayerSprites.flip_v = false
	$PlayerSprites.flip_h = velocity.x < 0
	
func sprint_Up(velocity):
	facing = "up"
	$PlayerSprites.animation = "sprint_up"
	$PlayerSprites.flip_v = false 
	
func sprint_Down(velocity):
	facing = "down"
	$PlayerSprites.animation = "sprint_down"
	$PlayerSprites.flip_v = false 

# Fungsi baru untuk menangani serangan
func attack_action():
	is_attacking = true
	
	# Mainkan animasi sesuai arah terakhir karakter menghadap
	if facing == "right":
		$PlayerSprites.play("slash_right")
	elif facing == "up":
		$PlayerSprites.play("slash_up")
	elif facing == "down":
		$PlayerSprites.play("slash_down")
	# Tunggu sampai animasi slash selesai berputar secara penuh (Fitur Godot 4)
	await get_tree().create_timer(0.3).timeout
	is_attacking = false
	idle()

func attacked():
	is_attacked = true
	
func _ready():
	screen_size = get_viewport_rect().size
	
func _process(delta):
	
	if Input.is_action_just_pressed("SPACE_input") and not is_attacking:
		attack_action()
		
	var velocity = Vector2.ZERO 
	var current_speed = speed
	# 2. Karakter hanya bisa bergerak jika TIDAK sedang menyerang
	if not is_attacking:
		if Input.is_action_pressed("A_input"):
			velocity.x -= 1 
		if Input.is_action_pressed("D_input"):
			velocity.x += 1 
		if Input.is_action_pressed("S_input"):
			velocity.y += 1
		if Input.is_action_pressed("W_input"):
			velocity.y -= 1
			
		var is_sprinting = Input.is_action_pressed("SHIFT_input")
		if is_sprinting:
			current_speed = speed + sprint
				
		if velocity.length() > 0:
			velocity = velocity.normalized() * current_speed
			
			if velocity.x != 0:
				if is_sprinting:
					sprint_RightLeft(velocity)
				else:
					walk_RightLeft(velocity)
			elif velocity.y < 0:
				if is_sprinting:
					sprint_Up(velocity)
				else:
					walk_Up(velocity)
			elif velocity.y > 0:
				if is_sprinting:
					sprint_Down(velocity)
				else:
					walk_Down(velocity)
					
			$PlayerSprites.play()
		else:
			idle()

	position += velocity * delta
	move_and_slide()
