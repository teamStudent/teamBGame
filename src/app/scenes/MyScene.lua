--
-- Author: Your Name
-- Date: 2016-03-09 13:29:21
--
local MyScene = class("MyScene",function()
	return display.newScene("MyScene")
end)

function MyScene:ctor()
	self:init()
end

local sceneNum
local chapterNum
local totalNumber
local enermyTypeNum
local totalNumber 
local mapdata
local prop
local scheduler=require(cc.PACKAGE_NAME..".scheduler")
function MyScene:init()

	self:initNums()
	self:initUI()
	self:initMapInfo()

  --时间调度，开始出怪
  -- self:createOneEnermy()
  -- self:createEnermy()

  self:testTouch()
  -- -- 时间调度，怪进入塔的攻击范围之内，开始攻击
  -- self:updata()
  -- --时间调度，清除已完成动作的
  -- self:removeUpdata()
  self:addEventListen()
  --升级的炮塔
  self.upTag=0
  --生成升级或者删除的按钮

    --触摸事件
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    	if event.name == "began" then
    		local x = math.floor(event.x/64)+1
    		local y = math.floor((640-event.y)/64)+1
    		--print(x,y)
    		--print(self.showLayer:getTileGIDAt(cc.p(x-1,y-1)))
    		return true

    	elseif event.name == "ended" then
    		
    	end
    end)


end

function MyScene:initMapInfo()
	--地图信息
    self.ColCount = 15
    self.RowCount = 10

    mapdata = {}
    for i = 1, self.ColCount do
      mapdata[i] = {}
      for j = 1, self.RowCount do
        mapdata[i][j] = 0
      end
    end

	  self.hero=self.map:getObjectGroup("object")
    self.showLayer=self.map:getLayer("showLayer")
    self.layer = self.map:getLayer("layer")
    --self.showLayer:hide()

    self.beginPoint = self.hero:getObject("begin")
    self.endPoint = self.hero:getObject("end")
    
    --终点旗帜
    local qizi = display.newSprite("GameScene/qizi.png"):pos(self.endPoint.x, self.endPoint.y):addTo(self.map,1)
    qizi:setAnchorPoint(cc.p(0,0))

    --代理传值
    prop = {}
    prop.col =self.ColCount
    prop.row = self.RowCount
    prop.startPos = { x = math.floor(self.beginPoint.x/64)+1 , y = math.floor((640-self.beginPoint.y)/64)+1 }
    prop.endPos = { x = math.floor(self.endPoint.x/64)+1, y =  math.floor((640-self.endPoint.y)/64)+1 }
    prop.getV = function(i,j)
        local Gid = self.showLayer:getTileGIDAt(cc.p(i-1,j-1))
        if Gid==51 then
          if mapdata[i][j] == 0 then
            return 0  
          end
        end  
        return 1 
	end


    --敌人
    self.enermy = Enermy.new():pos(self.beginPoint.x,self.beginPoint.y):addTo(self.map,1)
    self.enermy:setAnchorPoint(cc.p(0.5,0.5))
    self.enermy:runAction(cc.Sequence:create(cc.DelayTime:create(10.0),self:enemyMove()))

    --武器信息
    self.wuqi1Point=self.hero:getObject("wuqi1")
    self.wuqi2Point=self.hero:getObject("wuqi2")
    self.wuqi3Point=self.hero:getObject("wuqi3")
    self.wuqi4Point=self.hero:getObject("wuqi4")
    self.wuqi5Point=self.hero:getObject("wuqi5")


end

function MyScene:initUI()
	--添加背景
	local bg = display.newSprite("GameScene/sceneBg1.png")
	local scaleX = display.width/bg:getContentSize().width
  	local scaleY = display.height/bg:getContentSize().height
  	bg:setScale(scaleX,scaleY)
  	bg:pos(display.cx, display.cy)
  	self:addChild(bg)
  	--添加地图
  	self.map = cc.TMXTiledMap:create("map/game1_1.tmx"):addTo(self)
  	    --粒子特效
    local rain=cc.ParticleRain:createWithTotalParticles(2000)
     -- snow:setTexture( cc.Director:getInstance():getTextureCache():addImage("GameScene/flower.png"))
    rain:pos(display.cx, display.top)
    rain:addTo(self.map)

       --显示金币的数量
  local moneySp=display.newSprite("GameScene/money.png")
  moneySp:pos(display.left+30, display.top-23)
  moneySp:setScale(0.6)
  moneySp:addTo(self.map,1)
  self.moneyNumLabel=cc.ui.UILabel.new({
      text =self.money,
      color = cc.c3b(250, 250, 5),
      size = 14,
    })
  :align(display.CENTER, display.left+60, display.top-20)
  :addTo(self.map,1)

    --显示杀敌的数量
  local killEnermySp=display.newSprite("GameScene/dao.png")
  killEnermySp:pos((display.cx+display.left)/2, display.top-20)
  killEnermySp:setScale(0.6)
  killEnermySp:addTo(self.map)
  self.killEnermyNumLabel=cc.ui.UILabel.new({
      text =self.killEnermyNum,
      color = cc.c3b(250, 250, 5),
      size = 14,
    })
  :align(display.CENTER, (display.cx+display.left)/2+30, display.top-20)
  :addTo(self.map,1)

    --显示敌人波数
  local enermyNumSp=display.newSprite("GameScene/qizi.png")
  enermyNumSp:pos(display.cx-45, display.top-20)
  enermyNumSp:setScale(0.6)
  enermyNumSp:addTo(self.map)
  self.enermyNumLabel=cc.ui.UILabel.new({
      text =self.number.."/"..totalNumber,
      color = cc.c3b(250, 250, 5),
      size = 14,
    })
  :align(display.CENTER, display.cx-10, display.top-20)
  :addTo(self.map,1)

   --显示血量
 local hpNumSp=display.newSprite("GameScene/xueliang.png")
  hpNumSp:pos((display.cx+display.right)/2, display.top-20)
  hpNumSp:setScale(0.6)
  hpNumSp:addTo(self.map)
  self.hpNumLabel=cc.ui.UILabel.new({
      text =self.hp,
      color = cc.c3b(250, 250, 5),
      size = 14,
    })
  :align(display.CENTER, (display.cx+display.right)/2+30, display.top-20)
  :addTo(self,1)

  --暂停按钮
  local stopBtn = cc.ui.UIPushButton.new({normal = "GameScene/stopBtn.png"}, {scale9 = true})
  stopBtn:onButtonClicked(function(event)
    cc.Director:getInstance():pause()
    local stopLayer = StopLayer.new()
    stopLayer:setPosition(cc.p(0,0))
    self:addChild(stopLayer,3)
  end)
  stopBtn:setPosition(cc.p(display.width-30, display.height-30))
  stopBtn:setScale(0.4)
  self:addChild(stopBtn)
end

function MyScene:initNums()
	self.monsterNum=0     --怪物数
    self.number=1    --波数
    self.killEnermyNum=0  --杀敌数
    self.hp=10    
    self.isWin=false
    self.money = 9999
    totalNumber = 99

      --添加大炮
  self.cannon={}
  --敌人表
  self.monster={}
  --子弹
  self.bullet={}



end

function MyScene:addEventListen()
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function ( event )
       

       if event.name=="began" then
             
             if self.upTag==2 then
                   self.upTag=1
                  self.scope:removeFromParent()
                 
              end
            for k1,v1 in pairs(self.cannon) do
                local rect1= self:newRect(v1)

                if cc.rectContainsPoint(rect1,cc.p(event.x,event.y)) then
                    self.upSprite=v1
                    self.upSpritePos=k1
                    self:upOrDownConnon()
                end
                for k,v in pairs(self.monster) do
                local rect1= self:newRect(v)
                
                if cc.rectContainsPoint(rect1,cc.p(event.x,event.y)) then
                    local x= v:getPositionX()-v1:getPositionX()
                local y= v:getPositionY()-v1:getPositionY()
                local s = math.sqrt(x*x+y*y)
                --如果距离小于武器的攻击范围，那么攻击
                if s<=v1.scope then 
                    if v1.attack==true then
                        v1.attack=false
                        local delay = cc.DelayTime:create(v1.attackSpeed)
                        local func= cc.CallFunc:create(function (even)
                            even.attack=true
                        end)
                       local seq = cc.Sequence:create(delay,func)
                        v1:runAction(seq)
                        self:attack(v1,v)
                    end
                    break
                end 
                end  
               end
            end


            return true

        end      
    end)
end

function MyScene:changePath()
    self.enermy:stopAllActions()
    prop.startPos = {x = math.floor(self.enermy:getPositionX()/64)+1,y = math.floor((640-self.enermy:getPositionY())/64)+1}
    print(prop.startPos.x,prop.startPos.y)
    local x,y = math.floor(self.addSp:getPositionX()/64)+1,math.floor((640-self.addSp:getPositionY())/64+1)
    --mapdata[x][y] = 1
    self.enermy:runAction(self:enemyMove())
end

function MyScene:testTouch()
    local money1 = display.newSprite("GameScene/money.png")
    money1:pos(self.wuqi1Point.x-2,display.bottom+3)
    money1:setScale(0.4)
    money1:addTo(self.map)
      --显示需要金币的数量
     cc.ui.UILabel.new({
      text = "80",
      color = cc.c3b(250, 250, 5),
      size = 15,
    })
    :pos(self.wuqi1Point.x+3,display.bottom+8)
    :addTo(self.map)

    local showWuqi1=display.newSprite("GameScene/showWuqi.png")
    showWuqi1:pos(self.wuqi1Point.x, self.wuqi1Point.y)
    showWuqi1:addTo(self.map,2)
    local wuqi1 = display.newSprite("GameScene/wuqi1.png")
    wuqi1:setScale(0.8)
    wuqi1:pos(showWuqi1:getContentSize().width/2,showWuqi1:getContentSize().height/2)
    wuqi1:addTo(showWuqi1)
    wuqi1:setTouchEnabled(true)
    wuqi1:setTouchSwallowEnabled(false)
    wuqi1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)   
        if event.name=="began" then
            self.addSp=Wuqi1.new()
            self.showLayer:show()
            self.addSp:pos(event.x, event.y)
            self.addSp:setAnchorPoint(cc.p(0.5,0.5))
            self.addSp:addTo(self.map,2)
            return true
        elseif event.name=="moved" then
           self.addSp:pos(event.x, event.y) 
        elseif event.name=="ended" then
            self.showLayer:hide()
            local x= event.x/64
            local y = (640-event.y)/64
            local tileGid = self.showLayer:getTileGIDAt(cc.p(math.floor(x),math.floor(y)))
            mapdata[math.floor(x)+1][math.floor(y)+1] = 1
            local path = AStarFindRoute.init(prop)
            if tileGid<=0 or next(path) == nil then
                self.addSp:removeFromParent()
                mapdata[math.floor(x)+1][math.floor(y)+1] = 0
                return
            end
            for k,v in pairs(self.cannon) do
                local rect1= self:newRect(v)
                if cc.rectContainsPoint(rect1,cc.p(event.x,event.y)) then
                    self.addSp:removeFromParent()
                    return
                end
            end
            if self.money-self.addSp.make<0 then
                self.addSp:removeFromParent()
                return
            end
            self.addSp:pos(math.floor(x)*64+32, math.floor(10-y)*64+32)
            self.cannon[#self.cannon+1]=self.addSp
            self.money=self.money-self.addSp.make
            self.moneyNumLabel:setString(self.money)
            self:changePath()
        end
        
    end)
    
    
    local money2 = display.newSprite("GameScene/money.png")
    money2:pos(self.wuqi2Point.x-4, display.bottom+3)
    money2:setScale(0.4)
    money2:addTo(self.map)
      --显示需要金币的数量
     cc.ui.UILabel.new({
      text = "100",
      color = cc.c3b(250, 250, 5),
      size = 15,
    })
    :pos(self.wuqi2Point.x+1, display.bottom+8)
    :addTo(self.map)

    local showWuqi2=display.newSprite("GameScene/showWuqi.png")
    showWuqi2:pos(self.wuqi2Point.x, self.wuqi2Point.y)
    showWuqi2:addTo(self.map,2)
    local wuqi2 = display.newSprite("GameScene/wuqi2.png")
    wuqi2:setScale(0.8)
    wuqi2:pos(showWuqi2:getContentSize().width/2,showWuqi2:getContentSize().height/2)
    wuqi2:addTo(showWuqi2)
    wuqi2:setTouchEnabled(true)
    wuqi2:setTouchSwallowEnabled(false)
    wuqi2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
      if event.name=="began" then
            self.addSp=Wuqi2.new()
            self.showLayer:show()
            self.addSp:pos(event.x, event.y)
            self.addSp:setAnchorPoint(cc.p(0.5,0.5))
            self.addSp:addTo(self.map,2)
            return true

      elseif event.name=="moved" then
            self.addSp:pos(event.x, event.y)

       elseif event.name=="ended" then
            self.showLayer:hide()
            local x= event.x/64
            local y = (640-event.y)/64
            local tileGid = self.showLayer:getTileGIDAt(cc.p(math.floor(x),math.floor(y)))
            mapdata[math.floor(x)+1][math.floor(y)+1] = 1
            local path = AStarFindRoute.init(prop)
            if tileGid<=0 or next(path) == nil then
                self.addSp:removeFromParent()
                mapdata[math.floor(x)+1][math.floor(y)+1] = 0
                return
            end
            for k,v in pairs(self.cannon) do
                local rect1= self:newRect(v)
                if cc.rectContainsPoint(rect1,cc.p(event.x,event.y)) then
                    self.addSp:removeFromParent()
                    return
                end
            end
            if self.money-self.addSp.make<0 then
                self.addSp:removeFromParent()
                return
            end
            self.addSp:pos(math.floor(x)*64+32, math.floor(10-y)*64+32)
            self.cannon[#self.cannon+1]=self.addSp
            self.money=self.money-self.addSp.make
            self.moneyNumLabel:setString(self.money)
            self:changePath()
        end
    end)
  


    local money3 = display.newSprite("GameScene/money.png")
    money3:pos(self.wuqi3Point.x-4, display.bottom+3)
    money3:setScale(0.4)
    money3:addTo(self.map)
      --显示需要金币的数量
     cc.ui.UILabel.new({
      text = "120",
      color = cc.c3b(250, 250, 5),
      size = 15,
    })
    :pos(self.wuqi3Point.x+1, display.bottom+8)
    :addTo(self.map)

    local showWuqi3=display.newSprite("GameScene/showWuqi.png")
    showWuqi3:pos(self.wuqi3Point.x, self.wuqi3Point.y)
    showWuqi3:addTo(self.map,2)
    local wuqi3 =  display.newSprite("GameScene/wuqi3.png")
    wuqi3:setScale(0.8)
    wuqi3:pos(showWuqi3:getContentSize().width/2,showWuqi3:getContentSize().height/2)
    wuqi3:addTo(showWuqi3)
    wuqi3:setTouchEnabled(true)
    wuqi3:setTouchSwallowEnabled(false)
    wuqi3:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)   
        if event.name=="began" then
            self.addSp=Wuqi3.new()
            self.showLayer:show()
            self.addSp:pos(event.x, event.y)
            self.addSp:setAnchorPoint(cc.p(0.5,0.5))
            self.addSp:addTo(self.map,2)
            return true
        elseif event.name=="moved" then
           self.addSp:pos(event.x, event.y) 
        elseif event.name=="ended" then
            self.showLayer:hide()
            local x= event.x/64
            local y = (640-event.y)/64
            local tileGid = self.showLayer:getTileGIDAt(cc.p(math.floor(x),math.floor(y)))
            mapdata[math.floor(x)+1][math.floor(y)+1] = 1
            local path = AStarFindRoute.init(prop)
            if tileGid<=0 or next(path) == nil then
                self.addSp:removeFromParent()
                mapdata[math.floor(x)+1][math.floor(y)+1] = 0
                return
            end
            for k,v in pairs(self.cannon) do
                local rect1= self:newRect(v)
                if cc.rectContainsPoint(rect1,cc.p(event.x,event.y)) then
                    self.addSp:removeFromParent()
                    return
                end
            end
            if self.money-self.addSp.make<0 then
                self.addSp:removeFromParent()
                return
            end
            self.addSp:pos(math.floor(x)*64+32, math.floor(10-y)*64+32)
            self.cannon[#self.cannon+1]=self.addSp
            self.money=self.money-self.addSp.make
            self.moneyNumLabel:setString(self.money)
            self:changePath()
        end
        
    end)

    
    local money4 = display.newSprite("GameScene/money.png")
    money4:pos(self.wuqi4Point.x-4, display.bottom+3)
    money4:setScale(0.4)
    money4:addTo(self.map)
      --显示需要金币的数量
     cc.ui.UILabel.new({
      text = "200",
      color = cc.c3b(250, 250, 5),
      size = 15,
    })
    :pos(self.wuqi4Point.x+1, display.bottom+8)
    :addTo(self.map)

    local showWuqi4=display.newSprite("GameScene/showWuqi.png")
    showWuqi4:pos(self.wuqi4Point.x, self.wuqi4Point.y)
    showWuqi4:addTo(self.map,2)
    local wuqi4 =  display.newSprite("GameScene/wuqi4.png")
    wuqi4:setScale(0.8)
    wuqi4:pos(showWuqi4:getContentSize().width/2,showWuqi4:getContentSize().height/2)
    wuqi4:addTo(showWuqi4)
    wuqi4:setTouchEnabled(true)
    wuqi4:setTouchSwallowEnabled(false)
    wuqi4:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)   
        if event.name=="began" then
            self.addSp=Wuqi4.new()
            self.showLayer:show()
            self.addSp:pos(event.x, event.y)
            self.addSp:setAnchorPoint(cc.p(0.5,0.5))
            self.addSp:addTo(self.map,2)
            return true
        elseif event.name=="moved" then
           self.addSp:pos(event.x, event.y) 
        elseif event.name=="ended" then
            self.showLayer:hide()
            local x= event.x/64
            local y = (640-event.y)/64
            local tileGid = self.showLayer:getTileGIDAt(cc.p(math.floor(x),math.floor(y)))
            mapdata[math.floor(x)+1][math.floor(y)+1] = 1
            local path = AStarFindRoute.init(prop)
            if tileGid<=0 or next(path) == nil then
                self.addSp:removeFromParent()
                mapdata[math.floor(x)+1][math.floor(y)+1] = 0
                return
            end
            for k,v in pairs(self.cannon) do
                local rect1= self:newRect(v)
                if cc.rectContainsPoint(rect1,cc.p(event.x,event.y)) then
                    self.addSp:removeFromParent()
                    return
                end
            end
            if self.money-self.addSp.make<0 then
                self.addSp:removeFromParent()
                return
            end
            self.addSp:pos(math.floor(x)*64+32, math.floor(10-y)*64+32)
            self.cannon[#self.cannon+1]=self.addSp
            self.money=self.money-self.addSp.make
            self.moneyNumLabel:setString(self.money)
            self:changePath()
        end
        
    end)

    local money5 = display.newSprite("GameScene/money.png")
    money5:pos(self.wuqi5Point.x-4, display.bottom+3)
    money5:setScale(0.4)
    money5:addTo(self.map)
      --显示需要金币的数量
     cc.ui.UILabel.new({
      text = "300",
      color = cc.c3b(250, 250, 5),
      size = 15,
    })
    :pos(self.wuqi5Point.x+1, display.bottom+8)
    :addTo(self.map)

    local showWuqi5=display.newSprite("GameScene/showWuqi.png")
    showWuqi5:pos(self.wuqi5Point.x, self.wuqi5Point.y)
    showWuqi5:addTo(self.map,2)
    local wuqi5 = cc.Sprite:create("GameScene/wuqi5.png")
    wuqi5:pos(showWuqi5:getContentSize().width/2,showWuqi5:getContentSize().height/2)
    wuqi5:addTo(showWuqi5)
    wuqi5:setTouchEnabled(true)
    wuqi5:setTouchSwallowEnabled(false)
    wuqi5:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)   
        if event.name=="began" then
            self.showLayer:show()
            self.addSp=Wuqi5.new()
            self.addSp:pos(event.x, event.y)
            self.addSp:setAnchorPoint(cc.p(0.5,0.5))
            self.addSp:addTo(self.map,2)
            return true
        elseif event.name=="moved" then
           self.addSp:pos(event.x, event.y) 
        elseif event.name=="ended" then
            self.showLayer:hide()
            local x= event.x/64
            local y = (640-event.y)/64
            local tileGid = self.showLayer:getTileGIDAt(cc.p(math.floor(x),math.floor(y)))
            mapdata[math.floor(x)+1][math.floor(y)+1] = 1
            local path = AStarFindRoute.init(prop)
            if tileGid<=0 or next(path) == nil then
                self.addSp:removeFromParent()
                mapdata[math.floor(x)+1][math.floor(y)+1] = 0
                return
            end
            for k,v in pairs(self.cannon) do
                local rect1= self:newRect(v)
                if cc.rectContainsPoint(rect1,cc.p(event.x,event.y)) then
                    self.addSp:removeFromParent()
                    return
                end
            end
            if self.money-self.addSp.make<0 then
                self.addSp:removeFromParent()
                return
            end
            self.addSp:pos(math.floor(x)*64+32, math.floor(10-y)*64+32)
            self.cannon[#self.cannon+1]=self.addSp
            self.money=self.money-self.addSp.make
            self.moneyNumLabel:setString(self.money)
            self:changePath()
        end
        
    end)
end

function MyScene:upOrDownConnon()
    self.upTag=2
    self.scope=cc.Sprite:create("scope.png")
    self.scope:pos(self.upSprite:getPositionX(), self.upSprite:getPositionY())
    self.scope:setAnchorPoint(cc.p(0.5,0.5))
    self.scope:setScale(self.upSprite.scope/100)
    self.scope:addTo(self.map,2)
  

    if self.money-self.upSprite.upMake>=0 then
    self.upConnon=cc.Sprite:create("GameScene/up1.png")
    else
    self.upConnon=cc.Sprite:create("GameScene/up2.png")
    end
    self.upConnon:pos(self.scope:getContentSize().width/2+60, self.scope:getContentSize().height/2)
    self.upConnon:setAnchorPoint(cc.p(0.5,0.5))
    self.upConnon:addTo(self.scope,3)
    self.upConnon:setTouchEnabled(true)
    self.upConnon:setTouchSwallowEnabled(true)

    self.upConnon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name=="ended" then    
            if self.upSprite.currentLevel<3 then
              if (self.money-self.upSprite.upMake)<0 then 
                   return
              end
                self.upSprite.totalMake=self.upSprite.totalMake+self.upSprite.upMake
                self.money=self.money-self.upSprite.upMake
                self.upSprite.upMake=self.upSprite.upMake+10
                self.upSprite.removeMake=self.upSprite.totalMake*0.8
                self.upSprite.currentLevel=self.upSprite.currentLevel+1
                self.upSprite.scope=self.upSprite.scope*1.5
                self.scope:setScale(self.upSprite.scope/100)
                self.upSprite.firepower=self.upSprite.firepower+5*(self.upSprite:getTag()-9)
                self.moneyNumLabel:setString(self.money)
                if self.upSprite.currentLevel==3 then
                   self.upMakeLabel:setString("MAX")
                else
                  self.upMakeLabel:setString(self.upSprite.upMake)
                end
                
                self.removeMakeLabel:setString(self.upSprite.removeMake)
                
                
                 
                 if (self.money-self.upSprite.upMake)<0 then
                   
                   self.upConnon:removeFromParent()
                   self.upConnon=cc.Sprite:create("GameScene/up2.png")
                   self.upConnon:pos(self.scope:getContentSize().width/2+60, self.scope:getContentSize().height/2)
                   self.upConnon:setAnchorPoint(cc.p(0.5,0.5))
                   self.upConnon:addTo(self.scope,3)

                 end   
          end
       elseif event.name=="began" then
            return true
       end
    end)

  self.upMakeLabel=cc.ui.UILabel.new({
      text =self.upSprite.upMake,
      color = cc.c3b(250, 250, 5),
      size = 20,
    })
    :align(display.CENTER, self.upConnon:getPositionX()-3, self.upConnon:getPositionY()-35)
  :addTo(self.scope,3)

  if self.upSprite.currentLevel==3 then
      self.upMakeLabel:setString("MAX")
  else
      self.upMakeLabel:setString(self.upSprite.upMake)
  end
  
    self.downConnon=cc.Sprite:create("GameScene/money.png")
    self.downConnon:pos(self.scope:getContentSize().width/2-50, self.scope:getContentSize().height/2-10)
    self.downConnon:setAnchorPoint(cc.p(0.5,0.5))
    self.downConnon:setScale(0.8)
    self.downConnon:addTo(self.scope,3)
    self.downConnon:setTouchEnabled(true)
    self.downConnon:setTouchSwallowEnabled(true)
    self.downConnon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function ( event )
        if event.name=="began" then
          
            return true
        elseif event.name=="ended" then

            self.money=self.money+self.upSprite.removeMake
            self.moneyNumLabel:setString(self.money)
            self.upSprite:removeFromParent()
            table.remove(self.cannon,self.upSpritePos)
            self.scope:removeFromParent()
            self.upTag=1
        end
    end)
    self.removeMakeLabel=cc.ui.UILabel.new({
      text =self.upSprite.removeMake,
      color = cc.c3b(250, 250, 5),
      size = 20,
    })
    :align(display.CENTER, self.downConnon:getPositionX()-7, self.downConnon:getPositionY()-28)
    :addTo(self.scope,3)
end


function MyScene:newRect(v)
    if v==nil then
       return cc.rect(0,0,0,0)
    end
    local size = v:getContentSize()
    local x = v:getPositionX()
    local y = v:getPositionY()
    local rect = cc.rect(x-size.width/2, y-size.height/2,size.width, size.height)
    return rect
end

--怪物移动
function MyScene:enemyMove()

	local  move = {}
    --a*路径
  local path = AStarFindRoute.init(prop)
	local  enemy = self.map:getObjectGroup("object")
	if table.nums(path)>0 then
		for i = #path-1,1,-1 do
			move[#move+1] = cc.MoveTo:create(1, cc.p((path[i].x-1)*64+32,((self.RowCount-path[i].y)*64+32)))
		end
	end

	local seq = cc.Sequence:create(move)
	return seq
end


return MyScene