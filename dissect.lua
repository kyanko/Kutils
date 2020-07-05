require("delaunay")
require("Kutils")

dissect={}

function dissect.delete(point)
	local new_point={}
	for i=1,#point-1
		do
		for p=i+1,#point
			do
			if point[p].x and point[i].x
				then
				if point[p].x==point[i].x and point[p].y==point[i].y
					then
					point[p]={}
				elseif point[p].x>point[i].x
					then
					break
				end
			end
		end
		if point[i].x
			then
			new_point[#new_point+1]=point[i]
		end
	end
	return new_point
end

function dissect.to_triangle(point)--凸多边形(或无镂空)
	table.sort(point,function(a,b) return (a.x<b.x or (a.x==b.x and a.y<b.y)) end)
	point=dissect.delete(point)
	local tri=Delaunay.triangulate(table.unpack(point))
	for i=1,#tri
		do
		local tri_temp=("m %d %d l %d %d l %d %d "):format(tri[i].p1.x,tri[i].p1.y,tri[i].p2.x,tri[i].p2.y,tri[i].p3.x,tri[i].p3.y)
		local rx,ry=circle_rxy_inner(tri_temp)
		rx,ry=num(rx,1),num(ry,1)
		tri[i]={shape=tri_temp,x=rx,y=ry,shape1=Kshape.move(tri_temp,-rx,-ry)}
	end
	return tri
end

function dissect.to_triangle2(point,ass_shape)--凹多边形(或有镂空)
	table.sort(point,function(a,b) return (a.x<b.x or (a.x==b.x and a.y<b.y)) end)
	local tri=Delaunay.triangulate(table.unpack(point))
	local new_tri={}
	for i=1,#tri
		do
		local tri_temp=("m %d %d l %d %d l %d %d "):format(tri[i].p1.x,tri[i].p1.y,tri[i].p2.x,tri[i].p2.y,tri[i].p3.x,tri[i].p3.y)
		local rx,ry=circle_rxy_inner(tri_temp)
		rx,ry=num(rx,1),num(ry,1)
		if shape.contains_point(ass_shape,rx,ry)
			then
			local jud1=shape.contains_point(ass_shape,tri[i].p1.x,tri[i].p1.y)
			local jud2=shape.contains_point(ass_shape,tri[i].p2.x,tri[i].p2.y)
			local jud3=shape.contains_point(ass_shape,tri[i].p3.x,tri[i].p3.y)
			if jud1 or jud2 or jud3
				then
				new_tri[#new_tri+1]={shape=tri_temp,x=rx,y=ry,shape1=Kshape.move(tri_temp,-rx,-ry)}
			end
		end
	end
	return new_tri,pos
end

function dissect.rect(min_x,min_y,max_x,max_y,point_n,ctrl_n)
	ctrl_n=(ctrl_n and ctrl_n or 0)
	local pos={}
	for i=1,point_n
		do
		pos[#pos+1]=Point(math.random(min_x,max_x),math.random(min_y,max_y))
	end
	if ctrl_n~=0
		then
		local rect=Kshape.rect(min_x,min_y,max_x-min_x,max_y-min_y)
		local rpos=Kshape.get_point(rect,Kshape.len(rect)/ctrl_n)
		for i=1,#rpos
			do
			pos[#pos+1]=Point(rpos[i].x,rpos[i].y)
		end
	end
	return dissect.to_triangle(pos),dissect.delete(pos)
end

function dissect.round(x0,y0,r,point_n,ctrl_n)
	ctrl_n=(ctrl_n and ctrl_n or 0)
	local pos={}
	for i=1,point_n
		do
		local r0=math.random(0,r)+math.random()
		local rad0=math.rad(math.random(0,360)+math.random())
		local x,y=x0+r0*math.cos(rad0),y0+r0*math.sin(rad0)
		pos[#pos+1]=Point(num(x,1),num(y,1))
	end
	if ctrl_n~=0
		then
		local round=shape.round(x0,y0,r)
		local rpos=shape.get_point(round,Kshape.len(round)/ctrl_n)
		for i=1,#rpos
			do
			pos[#pos+1]=Point(rpos[i].x,rpos[i].y)
		end
	end
	return dissect.to_triangle(pos),pos
end

function dissect.ring(x0,y0,r1,r2,point_n,ctrl_n)
	ctrl_n=(ctrl_n and ctrl_n or 0)
	local pos={}
	local ring=shape.ring(x0,y0,r1,r2)
	for i=1,point_n
		do
		local r0=math.random(r1,r2)+math.random()
		local rad0=math.rad(math.random(0,360)+math.random())
		local x,y=x0+r0*math.cos(rad0),y0+r0*math.sin(rad0)
		pos[#pos+1]=Point(num(x,1),num(y,1))
	end
	if ctrl_n~=0
		then
		local rpos=shape.get_point(ring,Kshape.len(ring)/ctrl_n)
		for i=1,#rpos
			do
			pos[#pos+1]=Point(rpos[i].x,rpos[i].y)
		end
	end
	return dissect.to_triangle2(pos,ring),pos
end

function dissect.positive_edge(edge_n,x0,y0,r,point_n,ctrl_n)
	ctrl_n=(ctrl_n and ctrl_n or 0)
	local pos={}
	local s=Kshape.positive_edge(edge_n,x0,y0,r,90)
	local p=table.mix(Yutils.shape.to_pixels(s))
	for i=1,point_n
		do
		pos[#pos+1]=Point(p[i].x,p[i].y)
	end
	if ctrl_n~=0
		then
		local rpos=shape.get_point(s,Kshape.len(s)/ctrl_n)
		for i=1,#rpos
			do
			pos[#pos+1]=Point(rpos[i].x,rpos[i].y)
		end
	end
	return dissect.to_triangle(pos),pos
end

function dissect.fillet_star(vertex_n,x0,y0,R1,R2,r1,r2,vertex_style1,vertex_style2,point_n,ctrl_n)
	ctrl_n=(ctrl_n and ctrl_n or 0)
	local pos={}
	local s=Kshape.fillet_star(vertex_n,x0,y0,R1,R2,r1,r2,vertex_style1,vertex_style2,90)
	local p=table.mix(Yutils.shape.to_pixels(s))
	for i=1,point_n
		do
		pos[#pos+1]=Point(p[i].x+math.random(),p[i].y+math.random())
	end
	if ctrl_n~=0
		then
		local rpos=shape.get_point(s,Kshape.len(s)/ctrl_n)
		for i=1,#rpos
			do
			pos[#pos+1]=Point(rpos[i].x,rpos[i].y)
		end
	end
	return dissect.to_triangle2(pos,s),pos
end

function dissect.shape_to_tri(ass_shape,point_n,ctrl_n,mode)
	mode=(mode and mode or false)
	local pos={}
	local s=ass_shape
	local p=table.mix(Yutils.shape.to_pixels(s))
	for i=1,math.min(point_n,#p)
		do
		pos[#pos+1]=Point(p[i].x+math.random(),p[i].y+math.random())
	end
	if ctrl_n~=0
		then
		local rpos=shape.get_point(s,Kshape.len(s)/ctrl_n)
		for i=1,#rpos
			do
			pos[#pos+1]=Point(rpos[i].x,rpos[i].y)
		end
	end
	if mode
		then
		return dissect.to_triangle2(pos,s)
	else
		return dissect.to_triangle(pos),pos
	end
end

_G.dissect=dissect
return dissect
