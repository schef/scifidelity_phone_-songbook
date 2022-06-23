extends Node

const PLAYLIST_LOCATION = "res://res/score/playlist.json"
var playlist: Array
var song_index: int = 0
var page_index: int = 0

func load_playlist():
	var file = File.new()
	file.open(PLAYLIST_LOCATION, file.READ)
	var json = file.get_as_text()
	playlist = JSON.parse(json).result
	file.close()

func _ready():
	load_playlist()

func get_playlist():
	return playlist

func get_file():
	if song_index >= playlist.size():
		song_index = playlist.size() - 1
	if song_index < 0:
		song_index = 0
	var pages = playlist[song_index]["files"]
	if page_index >= pages.size():
		page_index = pages.size() - 1
	if page_index < 0:
		page_index = 0
	return pages[page_index]

func next_page():
	page_index = page_index + 1

func previous_page():
	page_index = page_index - 1
	
func next_song():
	song_index = song_index + 1
	page_index = 0
	
func previous_song():
	song_index = song_index - 1
	page_index = 0
	
func set_song(index):
	song_index = index
	page_index = 0

func get_max_songs():
	return playlist.size()
	
func get_max_pages():
	var pages = playlist[song_index]["files"]
	return pages.size()
