dirname = path.dirname(__file__)

world:new_immovable_type{
   name = "standing_stone7",
   descname = _ "Standing Stone",
   editor_category = "standing_stones",
   size = "none",
   attributes = {},
   programs = {},
   animations = {
      idle = {
         template = "idle",
         directory = dirname,
         hotspot = { 7, 63 },
      },
   }
}
