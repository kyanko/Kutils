require("Kfunc")
frag={}
function frag.rect(ass_shape,mw,mh)
	local x1,y1,x2,y2=shape.bounding_real(ass_shape)
	local pos={}
	local w,h=x2-x1,y2-y1
	for i=1,mw
		do
		for p=1,mh
			do
			pos[#pos+1]=Kshape.rect(x1+(i-1)*w/mw,y1+(p-1)*h/mh,w/mw,h/mh)
		end
	end
	return pos
end

function frag.tri(ass_shape,max_n)
	local x1,y1,x2,y2=shape.bounding_real(ass_shape)
	local pos={}
	local x0,y0=(x1+x2)/2,(y1+y2)/2
	local R=2*math.distance(x1-x0,y1-y0)
	for i=1,max_n
		do
		pos[#pos+1]=string.format("m %d %d l %d %d l %d %d ",x0,y0,x0+R*math.cos((i-1)*math.pi*2/max_n),y0-R*math.sin((i-1)*math.pi*2/max_n),x0+R*math.cos(i*math.pi*2/max_n),y0-R*math.sin(i*math.pi*2/max_n))
	end
	return pos
end

function frag.puzzle(ass_shape,rx,ry)
	local x1,y1,x2,y2=shape.bounding_real(ass_shape)
	local pos={}
	local w,h=x2-x1,y2-y1
	local r1=Kshape.rect(x1,y1,w-rx*w,ry*h)
	local r2=Kshape.rect(x2-rx*w,y1,rx*w,h-ry*h)
	local r3=Kshape.rect(x1+rx*w,y2-ry*h,w-rx*w,ry*h)
	local r4=Kshape.rect(x1,y1+ry*h,rx*w,h-ry*h)
	local r5=Kshape.rect(x1+rx*w,y1+ry*h,w-rx*w*2,h-h*ry*2)
	pos={r1,r2,r3,r4,r5}
	return pos
end
