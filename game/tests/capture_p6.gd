extends SceneTree
## P6 visual QA capture on a real virtual display, not the headless dummy renderer.
## No story changes; it instantiates only the approved Home/Gate/Refuge QA views.
const Main = preload("res://scripts/main.gd")

func _initialize() -> void:
    call_deferred("_capture")

func _shot(label: String) -> bool:
    await process_frame
    await RenderingServer.frame_post_draw
    var screenshot: Image = get_root().get_texture().get_image()
    if screenshot.is_empty() or screenshot.get_width() < 800 or screenshot.get_height() < 400:
        push_error("Invalid viewport capture for " + label)
        return false
    var target: String = "res://p6_visual_" + label + ".png"
    var err: Error = screenshot.save_png(target)
    if err != OK:
        push_error("Unable to save screenshot " + label)
        return false
    print("P6 VISUAL CAPTURE: ", label, " ", screenshot.get_width(), "x", screenshot.get_height())
    return true

func _capture() -> void:
    var main := Main.new()
    get_root().add_child(main)
    await process_frame
    if not await _shot("home"):
        quit(1)
        return
    main._show_gate()
    await process_frame
    if not await _shot("gate"):
        quit(1)
        return
    if not main.world.decide_gate("authorized", "valid_pass"):
        push_error("Unable to set up refuge visual fixture")
        quit(1)
        return
    if not main.world.finish_gate(true):
        quit(1)
        return
    main._show_home()
    await process_frame
    if not main.world.advance_day():
        quit(1)
        return
    main._show_refuge()
    await process_frame
    if not await _shot("refuge"):
        quit(1)
        return
    print("P6 VISUAL CAPTURE: 3 renders saved")
    quit(0)
