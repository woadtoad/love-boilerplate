local Pool = CLASS('pool')

function Pool:initialize(item,count,...)

  self.activeItemList = {}
  self.inactiveItemList = {}
  for i=1,count do

    --we need a key so that we are able to call the correct item back when we gotta due

    local RanKey = "key" .. tostring(love.timer.getTime())
    table.insert(self.ItemList,item:new(...))
    self.inactiveItemList[i]:setInactive()
    self.inactiveItemList[i].key = RanKey
  end

end

function Pool:makeActive(...)
  self.activeItemList[self.inactiveItemList[1].key] = self.inactiveItemList[1]
  table.remove(self.inactiveItemList,1)
end


function Pool:deactivate(key)
  table.insert(self.inactiveItemList,self.activeItemList[key])
  table.remove(self.activeItemList,key)
end


function Pool:draw()

  for i=1,#self.activeItemList do
    self.activeItemList[i]:draw()
  end

end

function Pool:update()

  for i=1,#self.activeItemList do
    self.activeItemList[i]:update()
  end

end

return Pool
