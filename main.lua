function love.load( ... )
    flux =          require 'flux'
	lg = love.graphics 
	spiralparms = 	{
					STEPS = 20,
					increment = 2*math.pi/20,
					segmentStart = 0,
					segmentStop = 2
					}
	love.mouse.setVisible(true)
	love.mouse.setGrabbed(false)
	lg.setPointSize(2)
	flux.to(spiralparms,1,{segmentStop = 50*math.pi}):ease("quadinout")
	flux.to(spiralparms,1.3,{segmentStart = 50*math.pi}):ease("quadinout")
	zap = true
end

function love.update(dt)
	flux.update(dt)
	if spiralparms.segmentStop >= 50*math.pi then
		spiralparms.segmentStop = 0 
		flux.to(spiralparms,4,{segmentStop = 50*math.pi}):ease("quadinout")
	end
	if spiralparms.segmentStart >= 50*math.pi then
		spiralparms.segmentStart = 0 
		flux.to(spiralparms,4,{segmentStart = 50*math.pi}):ease("quadinout")
	end
	local mx,my = love.mouse.getPosition()

	--spiralparms.STEPS = mx/4
	--if spiralparms.STEPS <= 0 then spiralparms.STEPS = 0.1 end
	local temp = mx/4
	if temp <= 0 then temp = 0.1 end

	--flux.to(spiralparms,0.25,{increment = (my/4)*math.pi/spiralparms.STEPS}):ease("quadinout")
	flux.to(spiralparms,0.1,{STEPS = temp,increment = (my/4)*math.pi/spiralparms.STEPS}):ease("linear")
end

function love.draw()
	local center = {x=lg.getWidth()/2,y=lg.getHeight()/2}
	local lastPoint =center
	local theta = spiralparms.increment
	local loopCount = 50*math.pi
		while loopCount >= 0 do
			local newPoint = {x=center.x+theta*math.cos(theta),y=center.y+theta*math.sin(theta)}

			lg.setColor(loopCount,-loopCount,loopCount/2,255)
		if zap then
			if loopCount > spiralparms.segmentStart and loopCount < spiralparms.segmentStop then
				lg.line(lastPoint.x,lastPoint.y,newPoint.x,newPoint.y)
			end
		else
			lg.line(lastPoint.x,lastPoint.y,newPoint.x,newPoint.y)
		end
			theta = theta + spiralparms.increment
			lastPoint=newPoint
			loopCount = loopCount - 1
		end
	
	lg.setColor(255,255,255,255)
	lg.point(spiralparms.STEPS*4,spiralparms.increment*spiralparms.STEPS/math.pi*4)
	lg.print(spiralparms.STEPS,10,20)
	lg.print(spiralparms.increment,10,10)
end

function love.keypressed(key, unicode)
	if key == 'escape' then
		love.event.push('quit')
	elseif key == 'n' then
		zap = not zap	
	elseif key == "tab" then
      local state = not love.mouse.isGrabbed()   -- the opposite of whatever it currently is
      love.mouse.setGrabbed(state) --Use love.mouse.setGrab(state) for 0.8.0 or lower
   end
end