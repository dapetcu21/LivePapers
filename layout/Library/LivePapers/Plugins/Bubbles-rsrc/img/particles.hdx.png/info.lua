textureMaps = {
  { fname = "map.png", { x = 0, y = 0, width = 341, height = 342 }, { x = 341, y = 0, width = 371, height = 370 }, { x = 712, y = 0, width = 406, height = 406 }, { x = 1118, y = 0, width = 459, height = 460 }, { x = 0, y = 460, width = 499, height = 498 }, { x = 499, y = 460, width = 500, height = 500 },  }
}
section("particles");
for i=0,5 do
  frame(i, 1.0/6)
end

default("particles");
