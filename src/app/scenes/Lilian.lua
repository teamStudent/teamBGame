--
-- Author: Your Name
-- Date: 2016-03-03 15:03:35

-- require("config")
-- require("framework.init")
-- local scheduler = require("framework.scheduler")
--
local Lilian=class("Lilian", function ()
	return display.newScene("Lilian")
end)

function Lilian:ctor()
	self:init()
end

function Lilian:init()
	local bg = display.newSprite("LiLianScene/bg.png")
	local scaleX = display.width/bg:getContentSize().width
	local scaleY = display.height/bg:getContentSize().height
	bg:setScale(scaleX, scaleY)
	bg:setPosition(cc.p(display.cx,display.cy))
	self:addChild(bg)

	local liLianTai = display.newSprite("LiLianScene/liLianTai.png")
	liLianTai:setPosition(cc.p(display.width*4.0/6, display.cy-100))
	self:addChild(liLianTai)

	local liLian_layer = display.newColorLayer(cc.c4b(200,200,0,255))
	liLian_layer:setAnchorPoint(cc.p(0,0))
	liLian_layer:pos(0, 0)
	-- liLian_layer:setPosition(cc.p(display.width/6.0, display.cy))
	liLian_layer:setContentSize(cc.size(display.width*0.333, display.height*2))

	local liLian_Scroll = cc.ScrollView:create(cc.size(display.width*0.333, display.height*2), liLian_layer)
	liLian_Scroll:setDirection(1)
	-- liLian_Scroll:setPosition(cc.p(display.width/6.0, display.cy))
	self:addChild(liLian_Scroll)

	for i=1,5 do
		local liLian_item = display.newSprite("wuqi"..i..".png")
		liLian_item:setPosition(cc.p(display.width/6.0, display.height - 150*i))
		liLian_Scroll:addChild(liLian_item)
	end

end

return Lilian