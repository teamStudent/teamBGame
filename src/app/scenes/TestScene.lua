\''
-- Author: Your Name
-- Date: 2016-03-08 10:29:55
--
local TestScene=class("TestScene", function ()
	return display.newScene("TestScene")
end)

function TestScene:ctor()
	self:init()
end

function TestScene:init()
	--初始化背景图
	local bg = display.newSprite("test_bg.png")
	bg:pos(display.cx,display.cy)
	self:addChild(bg)
	--  go to GameScene
	local backBtn = cc.ui.UIPushButton.new({normal="stargame.png"},{scale9=true})
                   :onButtonClicked(function(event)
                   display.replaceScene(require("app/scenes/MyGameScene"):new())
                   end)
                   :pos(display.cx, display.cy-200)
                   :addTo(self,1)


    

     --ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("hero1.png","hero10.plist","hero10.ExportJson")
     --local  armaature = ccs.Armature:create("hero1")
     		--armaature:getAnimation():playWithIndex(0)
     		--armaature:pos(display.cx+100, display.cy+100)
     		--addChild(armaature)


end

function TestScene:onEnter()
    

end

function TestScene:onExit()
  
end



return TestScene