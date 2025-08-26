extends Control

@onready var click: AudioStreamPlayer2D = $click




 

# Called when the node enters the scene tree for the first time
func _ready():
  pass# Ensure this path is correct # Ensure this matches your node name
 
#func ClickSoundPlayer():
 #   if click:
  #     click.play()  # Play the click sound
   # else:
    #   print("ClickSoundPlayer is null!")
        
        
# Function for Play button
func _on_button_pressed() -> void:
     $click.play()
     #await $click.finished
     #get_tree().change_scene_to_file("res://path_to_your_game_scene.tscn")  # Replace with your game scene path

 

# Function for Quit button
func _on_button_2_pressed() -> void:     
 $click.play()
  
 await $click.finished
 get_tree().quit()

func _on_options_button_pressed() -> void:
 $click.play()
 await $click.finished
 get_tree().change_scene_to_file("res://optins_menu.tscn")  
 


func _on_about_pressed() -> void:
    pass # Replace with function body.
