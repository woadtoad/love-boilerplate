local _M = CLASS("texmate")
--pass in the atlas, and it will make a deck, and preseve offset data. 
--framerate, works as a global number

function round(num, idp)

  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end

  return math.floor(num + 0.5)

end

function _M:initialize (Atlas,animlist,defaultanim,x,y,pivotx,pivoty,rot)

	self.Atlas = Atlas
	self.animlist = animlist
	self.activeAnim = defaultanim
	self.offset = {}
	self.offset.x = pivotx or 0
	self.offset.y = pivoty or 0
	self.batch = love.graphics.newSpriteBatch( Atlas.texture, 100, "stream" )
	self.iterator = 1
	self.active = true
	self.x = x or 100
	self.y = y or 100
	self.rot = rot or 0
	self.scale = {}
	self.scale.x = scalex or 1
	self.scale.y = scaley or 1

end

function _M:pause ()
	self.active = false
end

function _M:play ()
	self.active = true
end

function _M:changeAnim (anim)
	self.activeAnim = anim
end

function _M:changeLoc (x,y)
	self.x = x or self.x
	self.y = y or self.y
end

function _M:changeRot(angle)
	self.rot = angle 
	print(angle)
end

function _M:getLoc()
	return self.x,self.y 
end

function  _M:Destroy ()
	print("destroying animation")
end

function _M:update (dt)


	--Active is whether we want the sprite to animate or not. We increment an iterator using delta time to keep things frame rate independent
	if self.active == true then

		self.iterator = self.iterator + (self.animlist[self.activeAnim].framerate * dt)

		if self.iterator > #self.animlist[self.activeAnim].frames then
			self.iterator = 1
		end
		if self.iterator < 1 then
			self.iterator = 1
		end

	end
end

function _M:draw ()
	--Reset graphics colour back to white 
	love.graphics.setColor(255,255,255,255)


	--Binds the SpriteBatch to memory for more efficient updating. 
	self.batch:clear()
	self.batch:bind()

		--find the center of the sprite. 
		local tempWidth = self.Atlas.size[self.animlist[self.activeAnim].frames[round(self.iterator)]..".png"].width/2
		local tempHeight = self.Atlas.size[self.animlist[self.activeAnim].frames[round(self.iterator)]..".png"].height/2
		local atlas = self.Atlas.quads[self.animlist[self.activeAnim].frames[round(self.iterator)]..".png"]
		local extra = self.Atlas.extra[self.animlist[self.activeAnim].frames[round(self.iterator)]..".png"]

		--id = SpriteBatch:add( quad, x, y, r, sx, sy, ox, oy, kx, ky )
		--r is in radians

		self.batch:add( atlas,
						self.x, --x
						self.y, --y
						math.rad(self.rot), -- rot
						self.scale.x, -- scale x
						self.scale.y, -- scale y
						-extra[1]+tempWidth-self.offset.x, --pivotx, needs to add in the trimming data here. 
						-extra[2]+tempHeight-self.offset.y -- pivoty
					)


	self.batch:unbind()

	love.graphics.draw(self.batch)

end

return _M