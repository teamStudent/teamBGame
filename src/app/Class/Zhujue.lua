--
-- Author: Your Name
-- Date: 2016-03-09 11:14:42
--
Zhujue = class("Zhujue", function()
	return display.newSprite("houzi_2.png")
end)
function Zhujue:ctor()
	self.hp = 300
    self.life = cc.cc.Sprite:create("jindu.png")
    self.life:setAnchorPoint(cc.p(0,0.5))
    self.life:pos(0,50)
    self.life:addTo(self)
end
return Zhujue