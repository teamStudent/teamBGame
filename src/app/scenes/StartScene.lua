--
-- Author: student
-- Date: 2015-07-27 16:49:53
--
local StartScene=class("StartScene", function ()
	return display.newScene("StartScene")
end)

function StartScene:ctor()
	self:init()
end

function StartScene:init()
	local bg = display.newSprite("StartScene/bg.png")
	local scaleX = display.width/bg:getContentSize().width
	local scaleY = display.height/bg:getContentSize().height
	bg:setScale(scaleX,scaleY)
	bg:setPosition(cc.p(display.cx,display.cy))
	self:addChild(bg)
           
    local mall = display.newSprite("StartScene/mall.png")
    mall:setPosition(cc.p(display.cx,display.cy-100))
    --self.addChild(mall)

    self._startButton = cc.ui.UIPushButton.new({normal="StartScene/play.png"},{scale9=true})
                       :onButtonClicked(function(event)
                        display.replaceScene(SelectScene.new())
                       end)
                       :pos(display.cx, display.cy)
                       :addTo(self)
                       :setScale(1.5)

    --[[self._achieveButton = cc.ui.UIPushButton.new({normal = "StartScene/achieve.png"},{scale=true}) 
                        :onButtonClicked(function (event)
                        	display.replaceScene(SelectScene.new())
                        end)
                        :pos(display.cx, display.cy-10)
                        :addTo(self)
                        :setScale(1.5)

    self._mallButton = cc.ui.UIPushButton.new({normal = "StartScene/mall.png"},{scale = true})
                        :onButtonClicked(function(event)
                         display.replaceScene(SelectScene.new())
                        end)
                        :pos(display.cx, display.cy-80)
                        :addTo(self)
                        :setScale(1.5)]]


    self._liLianButton = cc.ui.UIPushButton.new({normal="StartScene/liLian.png"},{scale9=true})
    					:onButtonClicked(function (event)
    						--display.replaceScene(require("app.scenes.Lilian").new(), "fade",  0.5, display.COLOR_WHITE)
    						display.replaceScene(Lilian.new(), "fade", 0.8)
    					end)
    					:pos(display.cx, display.cy-150)
    					:addTo(self)
    					:setScale(1.2)
	
	local music = cc.ui.UICheckBoxButton.new({off ="sound_off.png" ,on = "sound_on.png"})
	music:setPosition(cc.p(display.width-50, display.top-50))
	music:setScale(0.5)
	music:onButtonStateChanged(function(event)
		if event.state == "on" then
			audio.resumeMusic()
			ModifyData.setMusic(true)
		elseif  event.state == "off" then
			audio.pauseMusic()
			ModifyData.setMusic(false)
			
		end
	end)
	music:setButtonSelected(true)
	music:addTo(self)

end

function StartScene:onEnter()
    audio.playMusic("music/fight.mp3",true)

end

function StartScene:onExit()
  
end



return StartScene