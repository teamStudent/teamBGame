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

	local backBtn = cc.ui.UIPushButton.new({normal="back.png"},{scale9=true})
                   :onButtonClicked(function(event)
                   	display.replaceScene(StartScene.new())
                   end)
                   :pos(display.right-50, display.top-50)
                   :addTo(self,1)

	local liLianTai = display.newSprite("LiLianScene/liLianTai.png")
	liLianTai:setPosition(cc.p(display.width*4.0/6, display.cy-100))
	self:addChild(liLianTai)

	-- local liLian_layer = display.newColorLayer(cc.c4b(200,200,0,255))
	-- liLian_layer:setContentSize(cc.size(display.width*0.444, display.height*3/2))
	-- liLian_layer:setAnchorPoint(cc.p(0,1-display.height/liLian_layer:getContentSize().height))
	-- liLian_layer:pos(0, display.height)
	-- liLian_layer:setPosition(cc.p(0, display.height))

	local liLian_Scroll = cc.ScrollView:create(cc.size(display.width*0.444, display.height))
	liLian_Scroll:setDirection(1)
	liLian_Scroll:setContentSize(cc.size(display.width*0.444, display.height*5/3))
	-- liLian_Scroll:setPosition(cc.p(0, 0))
	--liLian_Scroll:setContentOffset(300)
	self:addChild(liLian_Scroll)

	for i=1,5 do
		local liLian_item = display.newSprite("wuqi"..i..".png")
		liLian_item:setPosition(cc.p(display.width/10, display.height*(2*i - 1)/6))
		-- liLian_layer:addChild(liLian_item)
		liLian_Scroll:addChild(liLian_item)

		local item_Label = cc.ui.UILabel.new({
			text = "jhghj",
			color = cc.c3b(250, 250, 5),
			size = 24,
			})
		:setPosition(cc.p(display.width/10 + 100, display.height*(2*i - 1)/6))
		:addTo(liLian_Scroll)

		local liLianBtn = cc.ui.UIPushButton.new({normal="LiLianScene/liLian.png"}, {scale9=true})
							:onButtonClicked(function(event)
								local paoTai = display.newSprite("wuqi"..i..".png")
												:setPosition(liLian_item:convertToWorldSpace(cc.p(0,0)))
												:setScale(0.0)
												:addTo(self)
												:runAction(cc.Spawn:create(
													cc.MoveTo:create(1.0, cc.p(display.width*4.0/6, display.cy)),
													cc.ScaleTo:create(1.0, 1.0, 1.0)))
							end)
							:setPosition(cc.p(display.width/10 + 200, display.height*(2*i - 1)/6))
							:addTo(liLian_Scroll)

	end

end

return Lilian