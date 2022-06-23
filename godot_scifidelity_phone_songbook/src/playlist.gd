extends Control

onready var itemList = get_node("ColorRect/ItemList")

func _ready():
	itemList.connect("item_selected", self, "on_item_selected")
	var playlist = Songs.get_playlist()
	for i in range(len(playlist)):
		var song = playlist[i]
		var list_string = song["title"]
		if song["composer"] != "":
			list_string += " - " + song["composer"]
		itemList.add_item(list_string)
		
func on_item_selected(index: int):
	Songs.set_song(index - 1)
	ScoreViewer.open()
	itemList.unselect_all()
