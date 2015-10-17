dirname = path.dirname(__file__)

tribes:new_productionsite_type {
   msgctxt = "atlanteans_building",
   name = "atlanteans_gold_spinning_mill",
   -- TRANSLATORS: This is a building name used in lists of buildings
   descname = pgettext("atlanteans_building", "Gold Spinning Mill"),
   directory = dirname,
   icon = dirname .. "menu.png",
   size = "small",

   buildcost = {
		log = 2,
		granite = 1,
		planks = 1
	},
	return_on_dismantle = {
		log = 1,
		granite = 1
	},

   animations = {
		idle = {
			template = "idle_??",
			directory = dirname,
			hotspot = { 33, 64 },
		},
		working = {
			template = "idle_??", -- TODO(GunChleoc): No animation yet.
			directory = dirname,
			hotspot = { 33, 64 },
		}
	},

   aihints = {
		prohibited_till = 600
   },

	working_positions = {
		atlanteans_carrier = 1
	},

   inputs = {
		gold = 5
	},
   outputs = {
		"gold_thread"
   },

	programs = {
		work = {
			-- TRANSLATORS: Completed/Skipped/Did not start spinning gold because ...
			descname = _"spinning gold",
			actions = {
				"sleep=15000",
				"return=skipped unless economy needs gold_thread",
				"consume=gold",
				"animate=working 25000",
				"produce=gold_thread"
			}
		},
	},
}
