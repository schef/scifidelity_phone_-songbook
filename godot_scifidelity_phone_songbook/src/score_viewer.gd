extends CanvasLayer
const IMAGE_LOCATION = "res://res/score/"
onready var score_viewer = get_node("ScoreViewer")
onready var score_screen: TextureRect = get_node("ScoreViewer/ColorRect/TextureRect")
onready var song_index = get_node("ScoreViewer/ColorRect/SongIndex")
onready var page_index = get_node("ScoreViewer/ColorRect/PageIndex")
var screen_size: Vector2 = Vector2.ZERO
var timer = Timer.new()
var last_song_index = 0

func screen_metrics():
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 
	print(OS.get_window_size().x)
	print(OS.get_window_size().y)

func reload_screen_size():
	#screen_size = OS.get_real_window_size()
	screen_size = get_viewport().size
	screen_metrics()

func load_image():
	score_screen.texture = load(IMAGE_LOCATION + Songs.get_file())
	if Songs.song_index != last_song_index:
		song_index.text = str(Songs.song_index + 1) + "/" + str(Songs.get_max_songs())		
		last_song_index = Songs.song_index
	page_index.text = str(Songs.page_index + 1) + "/" + str(Songs.get_max_pages())	
	timer.wait_time = 0.3
	timer.start()

func _ready():
	score_viewer.visible = false
	timer.connect("timeout", self, "on_timeout")
	timer.one_shot = true
	add_child(timer)

func _input(event):
	if event is InputEventScreenTouch:
		if not score_viewer.visible:
			return
		if event.is_pressed():
			reload_screen_size()
			if event.position.x < screen_size.x/2:
				if event.position.y < screen_size.y/2:
					Songs.previous_song()
				elif event.position.y >= screen_size.y/2:
					Songs.previous_page()
			elif event.position.x >= screen_size.x/2:
				if event.position.y < screen_size.y/2:
					Songs.next_song()
				elif event.position.y >= screen_size.y/2:
					Songs.next_page()
			load_image()
	if event is InputEventKey:
		if event.is_action_pressed("ui_back"):
			hide()

func _notification(what):      
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: 
		hide()

func show():
	score_viewer.visible = true

func hide():
	score_viewer.visible = false

func open():
	load_image()
	show()

func on_timeout():
	song_index.text = ""
	page_index.text = ""
