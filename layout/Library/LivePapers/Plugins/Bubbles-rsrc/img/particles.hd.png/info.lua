textureMaps = {
  { fname = "map.png", { x = 0, y = 0, width = 170.5, height = 171 }, { x = 170.5, y = 0, width = 185.5, height = 185 }, { x = 356, y = 0, width = 203, height = 203 }, { x = 559, y = 0, width = 229.5, height = 230 }, { x = 0, y = 230, width = 249.5, height = 249 }, { x = 249.5, y = 230, width = 250, height = 250 },  }
}
section("particles");
for i=0,5 do
  frame(i, 1.0/6)
end

default("particles");
