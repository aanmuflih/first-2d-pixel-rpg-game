extends Label
# _process(delta) dipanggil setiap frame oleh Godot
func _process(delta):
	# 1. Mengambil angka FPS dari sistem (Engine) bawaan Godot
	var current_fps = Engine.get_frames_per_second()
	
	# 2. Mengubah teks pada Label
	# str() berfungsi untuk menyulap angka matematika menjadi teks biasa
	text = "FPS: " + str(current_fps)
