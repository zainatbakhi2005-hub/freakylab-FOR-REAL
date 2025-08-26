extends Control
@onready var click: AudioStreamPlayer2D = $click


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass





func _on_no_pressed() -> void:
    $click.play()
    await $click.finished
    get_tree().quit() # Replace with function body.


func _on_yes_pressed() -> void:
    $click.play()
    await $click.finished
    get_tree().change_scene_to_file("res://main_menu.tscn") # Replace with function body.
