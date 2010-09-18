-- =======================================================================
--                                Field test                               
-- =======================================================================
field_tests = lunit.TestCase("Field access")
function field_tests:test_access()
   c = wl.Map():get_field(25,32)
   assert_equal(c.x, 25)
   assert_equal(c.y, 32)
end
function field_tests:test_access_array()
   c = wl.Map():get_field{25,32}
   assert_equal(c.x, 25)
   assert_equal(c.y, 32)
end
function field_tests:test_access_array_with_strings()
   c = wl.Map():get_field{x=25,y=32}
   assert_equal(c.x, 25)
   assert_equal(c.y, 32)
end
function field_tests:test_access_no_x()
   assert_error("no x in table", function()
      wl.Map():get_field{z=5,y=32}
   end)
end
function field_tests:test_access_no_y()
   assert_error("no y in table", function()
      wl.Map():get_field{x=5,z=32}
   end)
end
function field_tests:test_access_no_y1()
   assert_error("no y in table", function()
      wl.Map():get_field{5,z=32}
   end)
end
function field_tests:test_access_xistobig()
   assert_error("x should be too big", function()
      wl.Map():get_field(64, 23)
   end)
end
function field_tests:test_access_xistobig1()
   assert_error("x should be too big", function()
      wl.Map():get_field{64, 23}
   end)
end
function field_tests:test_access_xistobig2()
   assert_error("x should be too big", function()
      wl.Map():get_field{x=64, y=23}
   end)
end
function field_tests:test_access_yistobig()
   assert_error("y should be too big", function()
      wl.Map():get_field(25, 80)
   end)
end
function field_tests:test_access_yistobig1()
   assert_error("y should be too big", function()
      wl.Map():get_field{25, 80}
   end)
end
function field_tests:test_access_yistobig2()
   assert_error("y should be too big", function()
      wl.Map():get_field{x=25, y=80}
   end)
end
function field_tests:test_access_xisnegativ()
   assert_error("x is negativ", function() wl.Map():get_field(-12, 23) end)
end
function field_tests:test_access_yisnegativ()
   assert_error("y is negativ", function() wl.Map():get_field(25, -12) end)
end
function field_tests:test_direct_change_impossible()
   assert_error("c.x should be read only", function() c.x = 12 end) 
   assert_error("c.y should be read only", function() c.y = 12 end) 
end
function field_tests:test_r_neighbour()
   c = wl.Map():get_field(25,40)
   assert_equal(wl.Map():get_field(26,40), c.rn)
   c = wl.Map():get_field(63,40)
   assert_equal(wl.Map():get_field(0,40), c.rn)
end
function field_tests:test_l_neighbour()
   c = wl.Map():get_field(25,40)
   assert_equal(wl.Map():get_field(24,40), c.ln)
   c = wl.Map():get_field(0,40)
   assert_equal(wl.Map():get_field(63,40), c.ln)
end
function field_tests:test_trn_neighbour()
   c = wl.Map():get_field(25,40)
   assert_equal(wl.Map():get_field(25,39), c.trn)
   assert_equal(wl.Map():get_field(26,38), c.trn.trn)
   assert_equal(wl.Map():get_field(26,37), c.trn.trn.trn)
   c = wl.Map():get_field(0,0)
   assert_equal(wl.Map():get_field(0,79), c.trn)
   assert_equal(wl.Map():get_field(1,78), c.trn.trn)
   assert_equal(wl.Map():get_field(1,77), c.trn.trn.trn)
end
function field_tests:test_tln_neighbour()
   c = wl.Map():get_field(25,40)
   assert_equal(wl.Map():get_field(24,39), c.tln)
   assert_equal(wl.Map():get_field(24,38), c.tln.tln)
   assert_equal(wl.Map():get_field(23,37), c.tln.tln.tln)
   c = wl.Map():get_field(1,1)
   assert_equal(wl.Map():get_field(1,0), c.tln)
   assert_equal(wl.Map():get_field(0,79), c.tln.tln)
   assert_equal(wl.Map():get_field(0,78), c.tln.tln.tln)
end
function field_tests:test_bln_neighbour()
   c = wl.Map():get_field(26,37)
   assert_equal(wl.Map():get_field(26,38), c.bln)
   assert_equal(wl.Map():get_field(25,39), c.bln.bln)
   assert_equal(wl.Map():get_field(25,40), c.bln.bln.bln)

   c = wl.Map():get_field(1,77)
   assert_equal(wl.Map():get_field(1,78), c.bln)
   assert_equal(wl.Map():get_field(0,79), c.bln.bln)
   assert_equal(wl.Map():get_field(0,0), c.bln.bln.bln)
end
function field_tests:test_brn_neighbour()
   c = wl.Map():get_field(35,22)
   assert_equal(wl.Map():get_field(35,23), c.brn)
   assert_equal(wl.Map():get_field(36,24), c.brn.brn)
   assert_equal(wl.Map():get_field(36,25), c.brn.brn.brn)

   c = wl.Map():get_field(63,79)
   assert_equal(wl.Map():get_field(0,0), c.brn)
   assert_equal(wl.Map():get_field(0,1), c.brn.brn)
   assert_equal(wl.Map():get_field(1,2), c.brn.brn.brn)
end
function field_tests:test_equality()
   c = wl.Map():get_field(32,33)
   c1 = wl.Map():get_field(32,33)

   assert_equal(c,c1)
end
function field_tests:test_inequality()
   c = wl.Map():get_field(32,33)
   c1 = wl.Map():get_field(33,32)

   assert_not_equal(c,c1)
end
function field_tests:test_getting_height()
   assert_equal(10, wl.Map():get_field(32,33).height)
end
function field_tests:test_setting_height()
   f = wl.Map():get_field(32,33)
   f.height = 12
   assert_equal(12, wl.Map():get_field(32,33).height)
   f.height = 10
end
function field_tests:test_setting_illegal_negativ_height()
   assert_error("height must be positive", function()
      wl.Map():get_field(50,40).height =  -12
   end)
end
function field_tests:test_setting_illegal_too_big_height()
   assert_error("height must be <= 60", function()
      wl.Map():get_field(50,40).height = 61
   end)
end
function field_tests:test_getting_terr()
   assert_equal("steppe", wl.Map():get_field(50,40).terr)
end
function field_tests:test_getting_terd()
   assert_equal("steppe", wl.Map():get_field(50,40).terd)
end
function field_tests:test_setting_terr()
   f = wl.Map():get_field(50,40)
   f.terr = "wasser"
   assert_equal("wasser", f.terr)
   f.terr = "steppe"
end
function field_tests:test_setting_terd()
   f = wl.Map():get_field(50,40)
   f.terd = "wasser"
   assert_equal("wasser", f.terd)
   f.terd = "steppe"
end
function field_tests:test_region_radius_zero()
   f = wl.Map():get_field(50,40)
   list = f:region(0)
   assert_equal(1, #list)
   assert_equal(f, list[1])
end
function field_tests:test_region_radius_one()
   f = wl.Map():get_field(50,40)
   list = f:region(1)
   assert_equal(7, #list)
end
function field_tests:test_hollow_region_radius_one()
   f = wl.Map():get_field(50,40)
   list = f:region(2,1)
   assert_equal(13, #list)
end

-- ==========
-- Resources 
-- ==========
field_resources_tests = lunit.TestCase("Field resources test")
function field_resources_tests:setup()
   self.f = wl.Map():get_field(60,40)
   self._res = self.f.resource
   self._amount = self.f.resource_amount
   self._terr = self.f.terr
   self._terd = self.f.terd
end
function field_resources_tests:teardown()
   self.f.terr = self._terr
   self.f.terd = self._terd
   self.f.resource = self._res
   self.f.resource_amount = self._amount 
end

function field_resources_tests:test_set_resource_amount()
   self.f.resource = "water"
   self.f.resource_amount = 25
   assert_equal("water", self.f.resource)
   assert_equal(25, self.f.resource_amount)
end
function field_resources_tests:test_set_resource_amount_negative()
   assert_error("negative forbidden!",
      function() self.f.resource_amount = -100 end)
end
function field_resources_tests:test_set_resource_amount_too_much()
   assert_error("too big!", function () self.f.resource_amount = 1000 end)
end
function field_resources_tests:test_set_resource_type()
   self.f.resource = "coal"
   assert_equal("coal", self.f.resource)
   assert_equal(self._amount, self.f.resource_amount)
end
function field_resources_tests:test_set_resource_type_illegal_resource()
   assert_error("Illegal name!", function() self.f.resource = "ksjdjhsdf" end)
end

-- TODO: do not make differences inside a test suite
function field_resources_tests:test_default_resource()
   -- In game, default resources are set. In the editor, no
   -- default resources are set
   if not wl.editor then
      assert_equal("water", self.f.resource)
      assert_equal(5, self.f.resource_amount)
   else
      -- The starting resource is the first in the world
      assert_equal("coal", self.f.resource)
      assert_equal(0, self.f.resource_amount)
   end
end





