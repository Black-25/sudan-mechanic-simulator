extends Node3D

const GAME_TITLE = "SUDAN MECHANIC SIMULATOR"

var game_started: bool = false

func _ready() -> void:
    print("================================")
    print(GAME_TITLE)
    print("Welcome, Adam!")
    print("Initializing mechanic workshop...")
    print("================================")

    setup_environment()

func setup_environment() -> void:
    var world_environment := WorldEnvironment.new()
    var environment := Environment.new()

    environment.background_mode = Environment.BG_SKY
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color(0.65, 0.68, 0.75)
    environment.ambient_light_energy = 0.8

    world_environment.environment = environment
    add_child(world_environment)

    var sun := DirectionalLight3D.new()
    sun.name = "Sun"
    sun.rotation_degrees = Vector3(-45, -30, 0)
    sun.light_energy = 1.2
    add_child(sun)

    print("Workshop environment initialized.")

func start_game() -> void:
    game_started = true
    print("The journey of Adam begins!")
