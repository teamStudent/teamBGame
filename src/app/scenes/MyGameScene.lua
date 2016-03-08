--
-- Author: Your Name
-- Date: 2016-03-08 11:00:43
--
local MyGameScene=class("MyGameScene", function ()
	return display.newScene("MyGameScene")
end)

function MyGameScene:ctor()
	self:init()
end

function MyGameScene:init()

	--local gamebg = display.newSprite("game_bg.jpg")
		  			--gamebg:pos(display.cx, display.cy)
		  			--self:addChild(gamebg)


    local map = cc.TMXTiledMap:create("map/game2-3.tmx")
    			self:addChild(map)

    local particle = cc.ParticleSystemQuad:create("Galaxy.plist")
          particle:pos(display.cx, display.cy)
          self:addChild(particle)

	


end

function MyGameScene:onEnter()
    

end

function MyGameScene:onExit()
  
end



return MyGameScene