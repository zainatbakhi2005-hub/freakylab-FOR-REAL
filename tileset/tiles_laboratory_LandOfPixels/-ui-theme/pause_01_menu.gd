extends Control
  
@onready var click: AudioStreamPlayer2D = $click
 


func _ready():
    # Ensure the game is paused when the Pause menu is ready
    get_tree().paused = true

  
@onready var pause: Control = $"."


# Called when the node enters the scene tree for the first time.
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
func _on_options_button_pressed() -> void:
   get_tree().change_scene_to_file("res://optins_menu.tscn")  
      

func _on_countinue_pressed() -> void:
    
    $click.play()
    await $click.finished
    
    #get_tree().change_scene_to_file("res://path_to_your_game_scene.tscn")  # Replace with your game scene path


func _on_exit_pressed() -> void:
 $click.play()
 await $click.finished
 get_tree().quit() 
  
   
