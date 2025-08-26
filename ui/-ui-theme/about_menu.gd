extends Control

# Declare member variables
var ClickSoundPlayer: AudioStreamPlayer

# Called when the node enters the scene tree for the first time
#func _ready():
   # ClickSoundPlayer = $ClickSoundPlayer  # Ensure this matches your node name
    # Load saved settings (if any)
   # var saved_volume = load_saved_volume()  # Implement this function to retrieve saved settings
   # $VolumeSlider.value = saved_volume  # Set the slider to the saved volume

# Function for Back button
func _on_Back_pressed():
    ClickSoundPlayer.play()
    get_tree().change_scene("res://main_menu.tscn" )  # Replace with your main menu scene path

# Function to adjust volume
func _on_VolumeSlider_value_changed(value):
    AudioServer.set_bus_volume_db(0, value_to_db(value))  # Adjust the audio bus volume based on slider
    save_volume(value)  # Implement this function to save the volume setting

# Convert volume percentage to decibels
func value_to_db(value: float) -> float:
    return linear_to_db(value / 100.0) if value > 0 else -80.0  # Handle 0 volume

# Sample function to save volume (implement your own saving mechanism)
func save_volume(value: float):
    var config = ConfigFile.new()
    config.load("user://settings.cfg")  # Load your settings file
    config.set_value("audio", "volume", value)
    config.save("user://settings.cfg")  # Save the settings back

# Sample function to load saved volume (implement your own loading mechanism)
func load_saved_volume() -> float:
    var config = ConfigFile.new()
    if config.load("user://settings.cfg") == OK:
        return config.get_value("audio", "volume", 100)  # Default to 100 if not set
    return 100


   


func _on_back_pressed() -> void:
# ClickSoundPlayer.play()
 print("Back button pressed")  # Debugging line
 get_tree().change_scene_to_file("res://main_menu.tscn")
  
