extends MarginContainer

func setup(info: Dictionary):
    $"Panel/VBoxContainer/LvlName".text %= info["lvl_nr"]
    $"Panel/VBoxContainer/TimeSec".text %= info["time"]
    $"Panel/VBoxContainer/For1Star/Label".text %= info["1star"]
    $"Panel/VBoxContainer/For2Star/Label".text %= info["2star"]
    $"Panel/VBoxContainer/For3Star/Label".text %= info["3star"]
    $"Panel/VBoxContainer/PrevPoints".text %= info["prev_points"]
