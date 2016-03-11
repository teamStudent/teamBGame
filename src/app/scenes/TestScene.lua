--
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
                    --display.replaceScene(StartScene.new())
                   end)
                   backBtn:setScale(0.8)
                   :pos(display.cx+20, display.cy-160)
                   :addTo(self,1)

 
    --ccs.ArmatureDataManager:getInstance():addArmatureFileInfo( "res/Hero0.png", "res/Hero0.plist" , "res/Hero.ExportJson" )
  
    --local armature = ccs. Armature:create( "Hero")
     		--armaature:getAnimation():playWithIndex(0)
     		--armaature:pos(display.cx+100, display.cy+100)
     		--armature :setPosition(origin. x + visibleSize.width / 3, origin .y + visibleSize. height / 5)
     		--armature :getAnimation(): play("attack")
     		--self:addChild(armaature)


     	local testsp = display.newSprite("testsp.png")
     		testsp:pos(0, display.cy-200)
     		self:addChild(testsp)


     		local action = cc.Spawn:create(  
    			cc.JumpBy:create(2, cc.p(960,0), 200, 4),  
    			cc.RotateBy:create( 2,  720))  
     		local sq = cc.Sequence:create(action, action:reverse()) 

     		local action2 = cc.RepeatForever:create(sq)   

     		testsp:runAction(action2)  



end

function TestScene:onEnter()
    

end

function TestScene:onExit()
  
end



return TestScene