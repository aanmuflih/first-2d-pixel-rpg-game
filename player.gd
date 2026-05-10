extends CharacterBody2D

var health = 100
var attack = 25
var sprint = 200
var speed = 200 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func idle():
	# Cek animasi terakhir saat tombol dilepas
	if $PlayerSprites.animation == "walk_right":
		$PlayerSprites.animation = "idle_right"
	elif $PlayerSprites.animation == "walk_up":
		$PlayerSprites.animation = "idle_up"
	elif $PlayerSprites.animation == "walk_down":
		$PlayerSprites.animation = "idle_down"

func walk_RightLeft(velocity):
	$PlayerSprites.animation = "walk_right"
	$PlayerSprites.flip_v = false
	$PlayerSprites.flip_h = velocity.x < 0
	
func walk_Up(velocity):
	$PlayerSprites.animation = "walk_up"
	$PlayerSprites.flip_v = false # Pastikan tidak terbalik
	
func walk_Down(velocity):
	$PlayerSprites.animation = "walk_down"
	$PlayerSprites.flip_v = false # Pastikan tidak terbalik
	
func _ready():
	screen_size = get_viewport_rect().size
	
func _process(delta):
	$PlayerSprites.play()
	var velocity = Vector2.ZERO # The player's movement vector.
	var current_speed = speed
	if Input.is_action_pressed("A_input"):
		velocity.x -= 1 # Diubah jadi minus (kiri)
	if Input.is_action_pressed("D_input"):
		velocity.x += 1 # Diubah jadi plus (kanan)
	if Input.is_action_pressed("S_input"):
		velocity.y += 1
	if Input.is_action_pressed("W_input"):
		velocity.y -= 1
	
	if Input.is_action_pressed("Sprint_input"):
		current_speed = speed + sprint

	if velocity.length() > 0:
		velocity = velocity.normalized() * current_speed
		# Panggil fungsi jalan sesuai arah
		if velocity.x != 0:
			walk_RightLeft(velocity)
			$PlayerSprites.play()
		elif velocity.y < 0:
			walk_Up(velocity)
			$PlayerSprites.play()
		elif velocity.y > 0:
			walk_Down(velocity)           
			$PlayerSprites.play()
	else:
# Panggil fungsi idle jika velocity 0
		idle()

	position += velocity * delta
	move_and_slide()
