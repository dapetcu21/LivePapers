textureMaps = {
  { fname = "map.png", { x = 0, y = 0, width = 85.25, height = 85.5 }, { x = 85.25, y = 0, width = 92.75, height = 92.5 }, { x = 178, y = 0, width = 101.5, height = 101.5 }, { x = 279.5, y = 0, width = 114.75, height = 115 }, { x = 0, y = 115, width = 124.75, height = 124.5 }, { x = 124.75, y = 115, width = 125, height = 125 },  }
}
section("particles");
for i=0,5 do
  frame(i, 1.0/6)
end

default("particles");
