from pathlib import Path
# super shitty little script to generate configs from the txts matthias gave me

p = Path("src/passengers")

conf_txt = """[Basics]

name="{pass_name_cap}"
imgpath="res://passengers/{pass_name}/{pass_name}_%s.png"
start_insanity=0
lore="{lore_txt}"

[TooCloseSensibility]

too_fast=30
insanity_effect=30
coll_size_mult=6
"""

def write_conf(fpath, name):
    # read in lore
    with open(fpath) as f:
        for nr, line in enumerate(f):
            if nr == 2:
                lore = line.strip(" \n")
    # write out conf
    new_conf_txt = conf_txt.format(pass_name_cap=name.capitalize(), pass_name=name, lore_txt=lore)
    with open(fpath.parent / f"{name}.cfg", "w") as f:
        f.write(new_conf_txt)

for path in p.iterdir():
    if path.is_dir():
        write_conf(path / f"{path.name}.txt", path.name)