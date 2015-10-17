dirname = path.dirname(__file__)

animations = {
   idle = {
      template = "idle_??",
      directory = dirname,
      hotspot = { 4, 26 },
   }
}
add_worker_animations(animations, "walk", dirname, "walk", {6, 26}, 10)
add_worker_animations(animations, "walkload", dirname, "walkload", {6, 26}, 10)


tribes:new_worker_type {
   msgctxt = "empire_worker",
   name = "empire_innkeeper",
   -- TRANSLATORS: This is a worker name used in lists of workers
   descname = pgettext("empire_worker", "Innkeeper"),
   directory = dirname,
   icon = dirname .. "menu.png",
   vision_range = 2,

   buildcost = {
		empire_carrier = 1,
		kitchen_tools = 1
	},

   animations = animations,
}
