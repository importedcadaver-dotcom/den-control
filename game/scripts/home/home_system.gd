extends RefCounted
## P3 home simulation. Solely manipulates approved family records in WorldState.home.
## Numbers are provisional simulation tuning, NOT new family biography or approved economy.

const BUTTON := "uc.family.button"
const HAZEL := "uc.family.hazel"
const MAMA := "uc.family.mama"
const CUB_IDS := [BUTTON, HAZEL]
const INTENTIONS := ["idle", "ask_food", "rest", "seek_mama", "play_indoors", "explore", "avoid", "protest", "watch", "recover"]
const ACTIONS := ["feed", "cuddle", "play", "clean", "carry", "put_down", "ask_tidy", "separate", "play_together", "first_aid"]
const NEEDS := ["hunger", "energy", "comfort", "curiosity", "stress", "health", "trust_mama"]
const MAX_MEMORIES := 40

static func initial_state() -> Dictionary:
    return {
        "sim_steps": 0,
        "selected_id": BUTTON,
        "holding_id": "",
        "cubs": {
            BUTTON: _cub(BUTTON, 30, 75, 72, 60, 16, 98, 66, 0.32),
            HAZEL: _cub(HAZEL, 38, 83, 70, 78, 22, 98, 57, 0.65)
        },
        "sibling": {"bond": 0, "resentment": 0, "conflicts": 0, "reconciliations": 0},
        "pantry_portions": 6, # P3 test capacity; not an approved economy balance.
        "mama": {"energy": 78, "concern": 30}
    }

static func _cub(id: String, hunger: int, energy: int, comfort: int, curiosity: int, stress: int, health: int, trust: int, x: float) -> Dictionary:
    return {"id": id, "hunger": hunger, "energy": energy, "comfort": comfort,
        "curiosity": curiosity, "stress": stress, "health": health, "trust_mama": trust,
        "intention": "idle", "ticks_on_intention": 0, "x": x, "y": 0.70,
        "memories": [], "last_action": "", "carried": false, "hurt": false}

static func _clamp(value: int) -> int:
    return clampi(value, 0, 100)

static func _change(cub: Dictionary, changes: Dictionary) -> void:
    for key in changes.keys():
        cub[key] = _clamp(int(cub[key]) + int(changes[key]))

static func _remember(cub: Dictionary, kind: String, sim_steps: int, detail: String) -> void:
    cub["memories"].append({"kind": kind, "step": sim_steps, "detail": detail})
    while cub["memories"].size() > MAX_MEMORIES:
        cub["memories"].pop_front()

static func valid(home: Variant) -> Array[String]:
    var errors: Array[String] = []
    if not home is Dictionary:
        errors.append("home must be dictionary")
        return errors
    if not _nonnegative_integer(home.get("sim_steps")):
        errors.append("invalid home simulation step")
    if not _signed_integer(home.get("pantry_portions"), 0, 20):
        errors.append("invalid home pantry")
    var cubs: Variant = home.get("cubs")
    if not cubs is Dictionary:
        errors.append("missing home cubs")
        return errors
    if cubs.size() != 2:
        errors.append("unapproved home cub")
    for id in CUB_IDS:
        var person: Variant = cubs.get(id)
        if not person is Dictionary:
            errors.append("missing approved home cub " + id)
            continue
        if person.get("id", "") != id:
            errors.append("home cub identity mismatch")
        for need in NEEDS:
            if not _signed_integer(person.get(need), 0, 100):
                errors.append("invalid home need " + need)
        if not INTENTIONS.has(person.get("intention", "")):
            errors.append("invalid home intention")
        if not _nonnegative_integer(person.get("ticks_on_intention")):
            errors.append("invalid intention duration")
        for axis in ["x", "y"]:
            var value: Variant = person.get(axis)
            if not (value is int or value is float) or not is_finite(float(value)) or float(value) < 0.0 or float(value) > 1.0:
                errors.append("invalid home location")
        if not person.get("carried") is bool or not person.get("hurt") is bool:
            errors.append("invalid cub flags")
        var memories: Variant = person.get("memories")
        if not memories is Array or memories.size() > MAX_MEMORIES:
            errors.append("invalid home memories")
        else:
            for item in memories:
                if not item is Dictionary or not item.get("kind", "") is String or not _nonnegative_integer(item.get("step")) or not item.get("detail", "") is String:
                    errors.append("invalid memory record")
        if not person.get("last_action", "") is String:
            errors.append("invalid last action")
    var holding: Variant = home.get("holding_id", null)
    if not holding is String or (holding != "" and not CUB_IDS.has(holding)):
        errors.append("invalid carried cub")
    if not CUB_IDS.has(home.get("selected_id", "")):
        errors.append("invalid selected cub")
    if holding is String and CUB_IDS.has(holding) and cubs.get(holding, {}) is Dictionary and not cubs[holding].get("carried", false):
        errors.append("holding flag mismatch")
    for id in CUB_IDS:
        if cubs.get(id, {}) is Dictionary and bool(cubs[id].get("carried", false)) != (holding == id):
            errors.append("orphan carried flag")
    var sibling: Variant = home.get("sibling")
    if not sibling is Dictionary:
        errors.append("missing sibling relationship")
    else:
        if not _signed_integer(sibling.get("bond"), -100, 100) or not _signed_integer(sibling.get("resentment"), 0, 100):
            errors.append("invalid sibling relationship")
        for field in ["conflicts", "reconciliations"]:
            if not _nonnegative_integer(sibling.get(field)):
                errors.append("invalid sibling history")
    var mama: Variant = home.get("mama")
    if not mama is Dictionary:
        errors.append("missing Mama home status")
    else:
        for field in ["energy", "concern"]:
            if not _signed_integer(mama.get(field), 0, 100):
                errors.append("invalid Mama status")
    return errors

static func _nonnegative_integer(value: Variant) -> bool:
    return _signed_integer(value, 0, 2147483647)

static func _signed_integer(value: Variant, low: int, high: int) -> bool:
    if value is int:
        return value >= low and value <= high
    if value is float:
        return is_finite(value) and value == floorf(value) and value >= low and value <= high
    return false

static func select(home: Dictionary, id: String) -> bool:
    if not CUB_IDS.has(id):
        return false
    home["selected_id"] = id
    return true

static func interact(home: Dictionary, id: String, action: String) -> Dictionary:
    if not CUB_IDS.has(id) or not ACTIONS.has(action):
        return {"ok": false, "reason": "Unknown approved cub or interaction"}
    var cub: Dictionary = home["cubs"][id]
    var other_id: String = HAZEL if id == BUTTON else BUTTON
    var other: Dictionary = home["cubs"][other_id]
    var sibling: Dictionary = home["sibling"]
    var mama: Dictionary = home["mama"]
    var tick: int = int(home["sim_steps"])
    var description := ""
    if action == "carry":
        if home["holding_id"] != "":
            return {"ok": false, "reason": "Mama is already carrying a cub"}
        if id == HAZEL and int(cub["stress"]) >= 68 and int(cub["trust_mama"]) < 65:
            cub["intention"] = "protest"
            _remember(cub, "refusal", tick, "Refused being picked up")
            return {"ok": true, "event": "home.refused", "description": "Hazel resists being carried. Mama cannot force an easy obedience outcome."}
        home["holding_id"] = id
        cub["carried"] = true
        _change(cub, {"comfort": 7, "stress": -5})
        cub["intention"] = "seek_mama"
        description = "Mama carries " + _name(id) + "."
    elif action == "put_down":
        if home["holding_id"] != id:
            return {"ok": false, "reason": "This cub is not being carried"}
        home["holding_id"] = ""
        cub["carried"] = false
        cub["intention"] = "idle"
        description = "Mama puts " + _name(id) + " down gently."
    elif action == "ask_tidy":
        # Refusal is contextual. Button tends to help; Hazel dislikes being ordered.
        if id == HAZEL and (int(cub["curiosity"]) > 45 or int(cub["stress"]) > 40):
            cub["intention"] = "avoid"
            _change(cub, {"stress": 5, "comfort": -3})
            _remember(cub, "refusal", tick, "Refused the tidy-up instruction")
            return {"ok": true, "event": "home.refused", "description": "Hazel ignores the tidy-up order and follows her own curiosity."}
        cub["intention"] = "play_indoors" if id == BUTTON else "idle"
        _change(cub, {"stress": -2, "comfort": 3})
        description = _name(id) + " agrees to help tidy, at least for now."
    elif action == "play_together":
        if home["holding_id"] != "" or int(cub["stress"]) >= 62 or int(other["stress"]) >= 62 or int(sibling["resentment"]) > 65:
            _remember(cub, "refusal", tick, "Not ready to play together")
            return {"ok": true, "event": "home.refused", "description": "The siblings are not ready to play together. Nothing is magically forgiven."}
        _change(cub, {"comfort": 8, "stress": -4, "curiosity": -8})
        _change(other, {"comfort": 8, "stress": -4, "curiosity": -8})
        sibling["bond"] = clampi(int(sibling["bond"]) + 5, -100, 100)
        sibling["resentment"] = clampi(int(sibling["resentment"]) - 3, 0, 100)
        sibling["reconciliations"] = int(sibling["reconciliations"]) + 1
        _remember(cub, "shared_play", tick, "Played together with sibling")
        _remember(other, "shared_play", tick, "Played together with sibling")
        description = "Both cubs play together briefly. Their feelings improve a little, not instantly."
    elif action == "separate":
        _change(cub, {"stress": -8})
        _change(other, {"stress": -8})
        mama["concern"] = clampi(int(mama["concern"]) + 2, 0, 100)
        description = "Mama separates the cubs and checks that they are safe."
    elif action == "feed":
        if home["holding_id"] != "" and home["holding_id"] != id:
            return {"ok": false, "reason": "Put the other cub down first"}
        if int(home["pantry_portions"]) <= 0:
            return {"ok": false, "reason": "Pantry is empty. P3 cannot create free food."}
        home["pantry_portions"] = int(home["pantry_portions"]) - 1
        _change(cub, {"hunger": -26, "comfort": 4, "trust_mama": 1})
        mama["energy"] = maxi(0, int(mama["energy"]) - 2)
        description = "Mama feeds " + _name(id) + " (one pantry portion used)."
    elif action == "cuddle":
        _change(cub, {"comfort": 20, "stress": -12, "trust_mama": 3})
        mama["energy"] = maxi(0, int(mama["energy"]) - 1)
        description = "Mama cuddles " + _name(id) + "."
    elif action == "play":
        if int(cub["energy"]) < 16:
            return {"ok": false, "reason": _name(id) + " is too tired to play"}
        _change(cub, {"curiosity": -22, "comfort": 7, "energy": -9, "stress": -4})
        description = "Mama plays with " + _name(id) + "."
    elif action == "clean":
        _change(cub, {"comfort": 5, "stress": -5, "trust_mama": 1})
        description = "Mama helps " + _name(id) + " get comfortable and clean."
    elif action == "first_aid":
        if not bool(cub["hurt"]):
            return {"ok": false, "reason": "No injury needs treatment"}
        _change(cub, {"health": 7, "stress": -8, "comfort": 4})
        cub["hurt"] = false
        description = "Mama checks " + _name(id) + "'s injury and provides care."
    cub["last_action"] = action
    _remember(cub, "mama." + action, tick, description)
    return {"ok": true, "event": "home.mama." + action, "description": description}

static func step(home: Dictionary, count: int = 1) -> Array[Dictionary]:
    var events: Array[Dictionary] = []
    if count < 1 or count > 32:
        return events
    for i in range(count):
        home["sim_steps"] = int(home["sim_steps"]) + 1
        var tick: int = int(home["sim_steps"])
        for id in CUB_IDS:
            var cub: Dictionary = home["cubs"][id]
            _change(cub, {"hunger": 1, "curiosity": 2, "energy": -1})
            if bool(cub["carried"]):
                _change(cub, {"comfort": 2, "stress": -2})
                cub["intention"] = "seek_mama"
                continue
            var intention: String = _choose_intention(cub, id, tick)
            if cub["intention"] != intention:
                cub["intention"] = intention
                cub["ticks_on_intention"] = 0
            cub["ticks_on_intention"] = int(cub["ticks_on_intention"]) + 1
            match intention:
                "ask_food":
                    _change(cub, {"stress": 1})
                "rest":
                    _change(cub, {"energy": 7, "stress": -2})
                "seek_mama":
                    _change(cub, {"comfort": 3, "stress": -2})
                "play_indoors":
                    _change(cub, {"curiosity": -6, "energy": -2, "comfort": 1})
                "explore":
                    _change(cub, {"curiosity": -7, "energy": -3, "stress": 1})
                "avoid":
                    _change(cub, {"stress": -1})
                "protest":
                    _change(cub, {"stress": 1})
                "recover":
                    _change(cub, {"comfort": 2, "stress": -3})
                _:
                    _change(cub, {"comfort": -1})
            # Simple bounded movement on a fixed floor, independent of UI animation.
            var target: float = _target_x(intention, id)
            cub["x"] = clampf(move_toward(float(cub["x"]), target, 0.055), 0.15, 0.78)
        var button: Dictionary = home["cubs"][BUTTON]
        var hazel: Dictionary = home["cubs"][HAZEL]
        var sibling: Dictionary = home["sibling"]
        var close: bool = home["holding_id"] == "" and absf(float(button["x"]) - float(hazel["x"])) < 0.22
        if close and tick % 5 == 0 and int(button["curiosity"]) > 25 and int(hazel["curiosity"]) > 25:
            # Competing interests sometimes create resentment before real fights.
            sibling["resentment"] = mini(100, int(sibling["resentment"]) + 12)
            _change(button, {"stress": 5, "comfort": -3})
            _change(hazel, {"stress": 7, "comfort": -4})
            _remember(button, "sibling.dispute", tick, "Argued over space and toys")
            _remember(hazel, "sibling.dispute", tick, "Argued over space and toys")
            events.append({"kind": "home.sibling_dispute", "subject_id": BUTTON,
                "details": {"other_id": HAZEL, "resentment": sibling["resentment"]}})
        if close and int(sibling["resentment"]) >= 40 and (int(button["stress"]) + int(hazel["stress"]) >= 60) and tick % 6 == 0:
            sibling["conflicts"] = int(sibling["conflicts"]) + 1
            sibling["resentment"] = mini(100, int(sibling["resentment"]) + 7)
            sibling["bond"] = maxi(-100, int(sibling["bond"]) - 9)
            _change(button, {"stress": 9, "comfort": -10})
            _change(hazel, {"stress": 11, "comfort": -11})
            var injury: bool = int(sibling["conflicts"]) % 3 == 0
            if injury:
                _change(button, {"health": -5})
                _change(hazel, {"health": -3})
                button["hurt"] = true
                hazel["hurt"] = true
            _remember(button, "sibling.fight", tick, "Sibling fight: feelings hurt" + ("; bruised" if injury else ""))
            _remember(hazel, "sibling.fight", tick, "Sibling fight: feelings hurt" + ("; bruised" if injury else ""))
            events.append({"kind": "home.sibling_conflict", "subject_id": BUTTON,
                "details": {"other_id": HAZEL, "injury": injury, "bond": sibling["bond"]}})
    return events

static func _choose_intention(cub: Dictionary, id: String, tick: int) -> String:
    if bool(cub["hurt"]) and int(cub["stress"]) > 55:
        return "recover"
    if int(cub["energy"]) < 33:
        return "rest"
    if int(cub["hunger"]) > 67:
        return "ask_food"
    if int(cub["comfort"]) < 48 or int(cub["stress"]) > 72:
        return "seek_mama" if id == BUTTON else "avoid"
    if id == BUTTON:
        return "seek_mama" if tick % 5 == 0 else "play_indoors"
    return "watch" if tick % 11 in [4, 5, 6, 7] else ("explore" if tick % 4 != 0 else "protest")

static func _target_x(intention: String, id: String) -> float:
    match intention:
        "seek_mama": return 0.23
        "rest": return 0.56
        "ask_food": return 0.43
        "play_indoors": return 0.37
        "watch": return 0.38
        "explore", "protest", "avoid": return 0.73
        _ : return 0.44 if id == BUTTON else 0.67

static func _name(id: String) -> String:
    return "Button" if id == BUTTON else "Hazel"
