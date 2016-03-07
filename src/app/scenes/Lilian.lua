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
	liLian_layer:setContentSize(cc.size(display.width*0.444, display.height*3/2))
	liLian_layer:setAnchorPoint(cc.p(0,1-display.height/liLian_layer:getContentSize().height))
	-- liLian_layer:pos(0, display.height)
	-- liLian_layer:setPosition(cc.p(0, display.height))

	local liLian_Scroll = cc.ScrollView:create(cc.size(display.width*0.444, display.height), liLian_layer)
	liLian_Scroll:setDirection(1)
	-- liLian_Scroll:setPosition(cc.p(0, 0))
	self:addChild(liLian_Scroll)

	for i=1,5 do
		local liLian_item = display.newSprite("wuqi"..i..".png")
		liLian_item:setPosition(cc.p(display.width/6, liLian_layer:getContentSize().height*(6-i)/6))
		liLian_layer:addChild(liLian_item)
		-- liLian_Scroll:addChild(liLian_item)
	end

end

return Lilian