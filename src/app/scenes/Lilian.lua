--
-- Author: Your Name
-- Date: 2016-03-03 15:03:35

-- require("config")
-- require("framework.init")
-- local scheduler = require("framework.scheduler")

local scheduler=require(cc.PACKAGE_NAME..".scheduler")

local Lilian=class("Lilian", function ()
	return display.newScene("Lilian")
end)

function Lilian:ctor()
	--初始化数据
	self:initData()
	--初始化UI等
	self:init()
	--定时器判断历炼的炮台是否完成历炼
	self:update()
end

function Lilian:initData()
	if cc.UserDefault:getInstance():getBoolForKey(FRISTLILIAN) == false then
		for i=1,5 do
			cc.UserDefault:getInstance():setIntegerForKey("WUQI"..i.."GRADE", 1)
		end
		cc.UserDefault:getInstance():setBoolForKey(FRISTLILIAN, true)
	end
end

function Lilian:update()
	local function judgeLiLianOver()
		--判断是否有炮台正在历炼
		if cc.UserDefault:getInstance():getBoolForKey(ISLILIAN) then
			local nowTime = os.time()
			local oldTime = cc.UserDefault:getInstance():getIntegerForKey(LILIANOFTIME)
			local grade = cc.UserDefault:getInstance():getIntegerForKey("WUQI"..cc.UserDefault:getInstance():getIntegerForKey(LILIANTAINUM).."GRADE")
			local hour = (nowTime - oldTime) / 3600
			--判断炮台是否历炼完成
			if hour >= (2*grade) then
				cc.UserDefault:getInstance():setBoolForKey(ISLILIAN, false)
				cc.UserDefault:getInstance():setIntegerForKey("WUQI"..cc.UserDefault:getInstance():getIntegerForKey(LILIANTAINUM).."GRADE", grade+1)
				cc.UserDefault:getInstance():setIntegerForKey(LILIANTAINUM, 0)
				self.paoTai:runAction(cc.Sequence:create(cc.FadeOut:create(0.3), cc.RemoveSelf:create()))
				scheduler.unscheduleGlobal(self.handle)
			end
		end
	end
	self.handle = scheduler.scheduleGlobal(judgeLiLianOver, 0.5)
end

function Lilian:init()
	--背景
	local bg = display.newSprite("LiLianScene/bg.png")
	local scaleX = display.width/bg:getContentSize().width
	local scaleY = display.height/bg:getContentSize().height
	bg:setScale(scaleX, scaleY)
	bg:setPosition(cc.p(display.cx,display.cy))
	self:addChild(bg)

	--返回
	local backBtn = cc.ui.UIPushButton.new({normal="back.png"},{scale9=true})
                   :onButtonClicked(function(event)
                   	display.replaceScene(StartScene.new())
                   end)
                   :pos(display.right-50, display.top-50)
                   :addTo(self,1)

    --历炼台
	local liLianTai = display.newSprite("LiLianScene/liLianTai.png")
	liLianTai:setPosition(cc.p(display.width*4.0/6, display.cy-100))
	self:addChild(liLianTai)
	--历炼Buff
	local liLianBuff = cc.ParticleSystemQuad:create("LiLianScene/buff.plist")
	liLianBuff:setPosition(cc.p(100, 100))
	liLianBuff:addTo(liLianTai)

	-- local liLian_layer = display.newColorLayer(cc.c4b(200,200,0,255))
	-- liLian_layer:setContentSize(cc.size(display.width*0.444, display.height*3/2))
	-- liLian_layer:setAnchorPoint(cc.p(0,1-display.height/liLian_layer:getContentSize().height))
	-- liLian_layer:pos(0, display.height)
	-- liLian_layer:setPosition(cc.p(0, display.height))

	--创建ScrollView
	local liLian_Scroll = cc.ScrollView:create(cc.size(display.width*0.444, display.height))
	liLian_Scroll:setDirection(1)
	liLian_Scroll:setContentSize(cc.size(display.width*0.444, display.height*5/3))
	-- liLian_Scroll:setPosition(cc.p(0, 0))
	--liLian_Scroll:setContentOffset(300)
	self:addChild(liLian_Scroll)

	--创建ScrollView的内容
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

		--历炼按钮
		local liLianBtn = cc.ui.UIPushButton.new({normal="LiLianScene/liLian.png"}, {scale9=true})
							:onButtonClicked(function(event)
								if cc.UserDefault:getInstance():getBoolForKey(ISLILIAN) == false then
								self.paoTai = display.newSprite("wuqi"..i..".png")
												:setPosition(liLian_item:convertToWorldSpace(cc.p(0,0)))
												:setScale(0.0)
												:addTo(self)
								self.paoTai:runAction(cc.Spawn:create(
													cc.MoveTo:create(1.0, cc.p(display.width*4.0/6, display.cy)),
													cc.ScaleTo:create(1.0, 1.0, 1.0)))
								--存储数据
								cc.UserDefault:getInstance():setBoolForKey(ISLILIAN, true)
								cc.UserDefault:getInstance():setIntegerForKey(LILIANTAINUM, i)
								cc.UserDefault:getInstance():setIntegerForKey(LILIANOFTIME, os.time())
								end
							end)
							:setPosition(cc.p(display.width/10 + 200, display.height*(2*i - 1)/6))
							:addTo(liLian_Scroll)
	end

	--有炮台历炼时重新进入该Scene时创建历炼炮台
	if cc.UserDefault:getInstance():getIntegerForKey(LILIANTAINUM) ~= 0 then
		self.paoTai = display.newSprite("wuqi"..cc.UserDefault:getInstance():getIntegerForKey(LILIANTAINUM)..".png")
		self.paoTai:setPosition(cc.p(display.width*4.0/6, display.cy))
		self:addChild(self.paoTai)
	end
end

function Lilian:onEnter()

end

function Lilian:onExit()
	scheduler.unscheduleGlobal(self.handle)
end

return Lilian