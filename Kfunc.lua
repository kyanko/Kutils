Yutils = require "Yutils"
shape = require "shape"
local format=string.format 
local gsub=string.gsub 
local gmatch=string.gmatch 
local match=string.match 
local reverse=string.reverse 
local sin=math.sin 
local cos=math.cos 
local rad=math.rad 
local deg=math.deg 
local asin=math.asin 
local acos=math.acos 
local atan=math.atan 
local min=math.min 
local max=math.max 
local pow=math.pow 
local abs=math.abs 
local floor=math.floor 
local ceil=math.ceil 
local modf=math.modf 
local fmod=math.fmod 
local sqrt=math.sqrt  
local random=math.random 
local concat=table.concat 
local insert=table.insert 
local remove=table.remove 
local sort=table.sort 

function kbug(err,value,val_name,val_type)
	local function find_val(val,tbl)
		local k=0
		for i=1,#tbl
			do
			if type(val)==tbl[i]
				then
				k=k+1
			end
		end
		return k>0
	end
	
	if type(val_type)=="table"
		then
		assert(find_val(value,val_type),err..val_name.." has to be a "..table.concat(val_type,"/").." value\nattempt to input a "..type(value).." value")
	else
		assert(type(value)==val_type,err..val_name.." has to be a "..val_type.." value\nattempt to input a "..type(value).." value")
	end
end

function gcd(a,b)
	if a%1~=0 or b%1~=0
		then
		error("a and b must be integer\n")
	else
		while(a%b~=0)
			do
			c=a%b
			a=b
			b=c
		end
	end
		return b
end

function mcm(a,b)
	if a%1~=0 or b%1~=0
		then
		error("a and b must be integer\n")
	else
		return a*b/gcd(a,b)
	end
end 

function float2frac(input)
	local k=0
	while(input%1~=0)
		do
		input=input*10
		k=k+1
	end
	local gc_d=gcd(input,10^k)
	return string.format("%d/%d",input/gc_d,10^k/gc_d)
end

function math.sign(num)
	if num>0
		then
		return 1
	elseif num<0
		then
		return -1
	else
		return 0
	end
end

function math.fmod_real(i,length,mode)
	if i>0
		then
		return math.fmod(i,length)
	elseif (i<0)
		then
		return math.fmod(i,length)+length
	else
		if mode=="loop"
			then
			return length
		else
			return 0
		end
	end
end

function math.average(...)
	local tbl={...}
	local sum=0
	for i=1,#tbl
		do
		sum=sum+tbl[i]
	end
	return sum/#tbl
end

function math.sum(...)
	local tbl={...}
	local sum=0
	for i=1,#tbl
		do
		sum=sum+tbl[i]
	end
	return sum
end

function math.cot(tan)
	return 1/math.tan(tan)
end

function math.distance(...)
	local sum=0
	for k,v in ipairs{...}
		do
		sum=sum+v^2
	end
	return math.sqrt(sum)
end

math.distance1=math.distance

function tobinary(num,digit)--十进制转换为二进制
	digit=(digit and digit or 8)
	local str1=""
	local str2=""
	local sign=math.sign(num)
	num=math.abs(num)
	local int,float=math.modf(num)
	local int1=int
	local float1=float
	repeat
		str1=math.fmod(int1,2)..str1
		int1=math.floor(int1/2)
	until int1==0
	if float1~=0
		then
		str2="."
		repeat
			str2=str2..math.floor(float1*2)
			float1=float1*2-math.modf(float1*2)
		until (float1==0 or math.abs(float1)<0.1)
	else
		str2=""
	end
	if digit<unicode.len(str1..str2)
		then
		return (sign==-1 and "-" or "")..str1..str2
	else
		for i=1,digit-unicode.len(str1..str2)
			do
			str1="0"..str1
		end
		return (sign==-1 and "-" or "")..str1..str2
	end
end

function permu(m,n)--number，排列
	if (m<0 or n<0)
		then
		error("m and n must be greater than 0")
	else
	local out=1
	if n>m
		then
		error("n must be smaller than m")
	else
		for i=m,m-n+1,-1
			do
			out=out*i
		end
	end
	return out
end
end

function combin(m,n)--number，组合
	if m==n
		then
		return 1
	else
		return permu(m,n)/permu(n,n)
	end
end

function bezier_count(tbl,layer,t)--number，计算贝塞尔曲线坐标
	if #tbl~=layer+1
		then
		error("控制点数组长度 不等于 阶数+1")
	else
		local x,y=0,0
		for i=0,layer
		do
		x,y=x+combin(layer,i)*math.pow(t,i)*math.pow(1-t,layer-i)*tbl[i+1].x,y+combin(layer,i)*math.pow(t,i)*math.pow(1-t,layer-i)*tbl[i+1].y
	end
	return num(x,2),num(y,2)
end
end

function periodic(func,T,x)--number，周期函数
	if type(func)=="function"
		then
	local T_n=math.floor(x/T)
	return func(x-T_n*T)
	else error("func must be a function value\n")
	end
end

function loop_n2(tbl)
	local loop={}
	local sum=0
	for i=1,#tbl
		do
		sum=sum+tbl[i]
		for p=1,tbl[i]
			do
			loop[#loop+1]={j1=p,j2=i,max1=tbl[i],max2=#tbl}
		end
	end
	return loop,sum
end

function loop_n3(tbl)
	local loop={}
	local sum=0
	for i=1,#tbl
		do
		for p=1,#tbl[i]
			do
			sum=sum+tbl[i][p]
			for q=1,tbl[i][p]
				do
				loop[#loop+1]={j1=q,j2=p,j3=i,max1=tbl[i][p],max2=#tbl[i],max3=#tbl}
			end
		end
	end
	return loop,sum
end

function frame_fad(alpha,duration,dur1,dur2,i,max)--string，透明度逐帧渐变
	local err="wrong input to function:Kframe.fad(alpha,duration,dur1,dur2,j,maxj)\n"
	kbug(err,alpha,"alpha","number")
	kbug(err,duration,"duration","number")
	kbug(err,dur1,"dur1","number")
	kbug(err,dur2,"dur2","number")
	kbug(err,i,"j","number")
	kbug(err,max,"maxj","number")
	local tag=""
	i1,i2=math.ceil(dur1*max/duration),max-math.ceil(dur2*max/duration)
	if i<=i1
		then
		local a0=(i1<=1 and alpha or 255-(255-alpha)*(i-1)/(i1-1))
		tag=_G.ass_alpha(a0)
	elseif i>i2
		then
		local a0=(i2==max and alpha or alpha+(255-alpha)*(i-i2-1)/(max-i2))
		tag=_G.ass_alpha(a0)
	else
		tag=_G.ass_alpha(alpha)
	end
	return tag
end

local function frame_t_color(tag,para1,para2,duration,t1,t2,a,j,maxj)
	if j/maxj>=t1/duration and j/maxj<=t2/duration
		then
		local t=((j/maxj-t1/duration)/((t2-t1)/duration))^a
		return "\\"..tag..color_gradient(para1,para2,t)
	elseif j/maxj<t1/duration
		then
		return "\\"..tag..para1
	else
		return "\\"..tag..para2
	end
end

local function frame_t_alpha(tag,para1,para2,duration,t1,t2,a,j,maxj)
	if j/maxj>=t1/duration and j/maxj<=t2/duration
		then
		local t=((j/maxj-t1/duration)/((t2-t1)/duration))^a
		return "\\"..tag..interpolate_alpha1(para1,para2,t)
	elseif j/maxj<t1/duration
		then
		return "\\"..tag..para1
	else
		return "\\"..tag..para2
	end
end

function frame_t(tag,para1,para2,duration,j,maxj,...)--string，逐帧渐变
	local err="wrong input to function:Kframe.t(tag,para1,para2,duration,j,maxj,...)\n"
	kbug(err,tag,"tag","string")
	kbug(err,para1,"para1",{"string","table","number"})
	kbug(err,para2,"para2",{"string","table","number"})
	kbug(err,duration,"duration","number")
	kbug(err,j,"j","number")
	kbug(err,maxj,"maxj","number")
	local tbl={...}
	local len=select("#",...)
	if len==0
		then
		a,t1,t2=1,0,duration
	elseif len==1
		then
		a,t1,t2=tbl[1],0,duration
	elseif len==2
		then
		a,t1,t2=1,tbl[1],tbl[2]
	elseif len==3
		then
		a,t1,t2=tbl[3],tbl[1],tbl[2]
	else
		error("bad arguments #"..#tbl.."to t")
	end
	kbug(err,a,"accel","number")
	kbug(err,t1,"t1","number")
	kbug(err,t2,"t2","number")
	local function ft_single(tag,para1,para2,duration,t1,t2,a,j,maxj)
		if type(para1)=="string"
			then
			local r,g,b=get_RGB(para1)
			if r and g and b
				then
				return frame_t_color(tag,para1,para2,duration,t1,t2,a,j,maxj)
			else
				return frame_t_alpha(tag,para1,para2,duration,t1,t2,a,j,maxj)
			end
		elseif type(para1)=="number"
			then
			if j/maxj>=t1/duration and j/maxj<=t2/duration
				then
				local t=((j/maxj-t1/duration)/((t2-t1)/duration))^a
				return "\\"..tag..num(t*para2+(1-t)*para1,1)
			elseif j/maxj<t1/duration
				then
				return "\\"..tag..para1
			else
				return "\\"..tag..para2
			end
		end
	end
	local str=""
	if type(para1)=="table"
		then
		for i=1,#para1
			do
			str=str..ft_single(tag:match("[^\\]+"),para1[i],para2[i],duration,t1,t2,a,j,maxj)
			tag=tag:gsub("[^\\]+","",1)
		end
	else
		str=ft_single(tag,para1,para2,duration,t1,t2,a,j,maxj)
	end
	return str
end

local function pfa(duration,t1,t2,t3,t4,t5,j,maxj)
	local ms=duration/maxj
	if j*ms<=t5
		then
		return 0
	else
		local tr=j*ms-t5-math.floor((j*ms-t5)/(t1+t2+t3+t4))*(t1+t2+t3+t4)
		if tr<=t1
			then
			return tr/t1
		elseif tr>t1 and tr<=t1+t2
			then
			return 1
		elseif tr>t1+t2 and tr<=t1+t2+t3
			then
			return 1-(tr-t1-t2)/(t3)
		else
			return 0
		end
	end
end

function frame_autotag(tag,para1,para2,duration,t1,t2,t3,t4,t5,j,maxj)--table，单个标签逐帧AutoTag(参数为实数)
	local err="wrong input to function:Kframe.autotag(tag,para1,para2,duration,t1,t2,t3,t4,t5,j,maxj)\n"
	kbug(err,tag,"tag","string")
	kbug(err,para1,"para1",{"string","table","number"})
	kbug(err,para2,"para2",{"string","table","number"})
	kbug(err,duration,"duration","number")
	kbug(err,t1,"t1","number")
	kbug(err,t2,"t2","number")
	kbug(err,t3,"t3","number")
	kbug(err,t4,"t4","number")
	kbug(err,t5,"t5","number")
	kbug(err,j,"j","number")
	kbug(err,maxj,"maxj","number")
	local function fa_single(tag,para1,para2,duration,t1,t2,t3,t4,t5,j,maxj)
		local t=pfa(duration,t1,t2,t3,t4,t5,j,maxj)
		if type(para1)=="string"
			then
			local r,g,b=get_RGB(para1)
			if r and g and b
				then
				return "\\"..tag..color_gradient(para1,para2,t)
			else
				return "\\"..tag..interpolate_alpha1(para1,para2,t)
			end
		elseif type(para1)=="number"
			then
			local para=num(para2*t+para1*(1-t),1)
			return "\\"..tag..para
		end
	end
	local out=""
	if (type(para1)~="table")
		then
		return fa_single(tag,para1,para2,duration,t1,t2,t3,t4,t5,j,maxj)
	else
		local k=0
		for s in tag:gmatch("[^\\]+")
			do
			k=k+1
			out=out..fa_single(s,para1[k],para2[k],duration,t1,t2,t3,t4,t5,j,maxj)
		end
		return out
	end
end

function frame_AutoTag(tag,para,duration,t1,t2,t3,t4,t5,ms)--table，多个标签逐帧AutoTag
	local out_tag={}
	if type(tag)~="table"
		then
		error("tag must be a table value",2)
	else
		out_tag=frame_autotag(tag[1],para[1].s,para[1].e,duration,t1,t2,t3,t4,t5,ms)
		for p=2,#tag
			do
			for i=1,#out_tag
				do
				out_tag[i]=out_tag[i]..frame_autotag(tag[p],para[p].s,para[p].e,duration,t1,t2,t3,t4,t5,ms)[i]
			end
		end
		return out_tag,duration
	end
end

function frame_autotag_alpha(tag,para1,para2,duration,t1,t2,t3,t4,t5,ms)--table，单个透明度标签逐帧AutoTag
	local dur=duration
	local T=t1+t2+t3+t4
	local tag_out={}
	local dur_real=duration-t5
	local max_n1,max_n2=math.ceil(t5/ms),math.ceil(dur_real/ms)
	for i=1,max_n1
		do
		tag_out[i]=tag..string.gsub(_G.ass_alpha(para1),"&","")
	end
	for i=1,max_n2
		do
		local para_t=periodic(
			function(x)
			if x<=t1
				then
				return x/t1
				elseif (x>t1 and x<=t1+t2)
					then
					return 1
					elseif (x>t1+t2 and x<=t1+t2+t3)
						then
						return 1-(x-t1-t2)/t3
						else
							return 0 
							end
							end,T,i*dur_real/max_n2)
		local para=string.gsub(_G.ass_alpha(num(para2*para_t+para1*(1-para_t),2)),"&","")
		tag_out[#tag_out+1]=tag..para
	end
	return tag_out,duration
end

function frame_AutoTag_alpha(tag,para,duration,t1,t2,t3,t4,t5,ms)--table，多个透明度标签逐帧AutoTag
	local out_tag={}
	if _G.type(tag)~="table"
		then
		_G.error("tag must be a table value",2)
	else
		out_tag=frame_autotag_alpha(tag[1],para[1].s,para[1].e,duration,t1,t2,t3,t4,t5,ms)
	for p=2,#tag
		do
		for i=1,#out_tag
			do
			out_tag[i]=out_tag[i]..frame_autotag_alpha(tag[p],para[p].s,para[p].e,duration,t1,t2,t3,t4,t5,ms)[i]
	end
end
return out_tag,duration
end
end

function frame_AutoTag_alpha1(tag,para,duration,t1,t2,t3,t4,t5,ms)--table，多个透明度标签逐帧AutoTag
	local out_tag={}
	if type(tag)~="table"
		then
		error("tag must be a table value",2)
	else
		for i=1,#tag
			do
			out_tag[i]=frame_autotag_alpha(tag[i],para[i].s,para[i].e,duration,t1,t2,t3,t4,t5,ms)
		end
	end
	return out_tag
end

function frame_autotag_color(tag,color1,color2,duration,t1,t2,t3,t4,t5,ms)
	local dur=duration
	local T=t1+t2+t3+t4
	local tag_out={}
	local dur_real=duration-t5
	local max_n1,max_n2=math.ceil(t5/ms),math.ceil(dur_real/ms)
	for i=1,max_n1
		do
		tag_out[i]=tag..para1
	end
	for i=1,max_n2
		do
		local para_t=periodic(
			function(x)
			if x<=t1
				then
				return x/t1
				elseif (x>t1 and x<=t1+t2)
					then
					return 1
					elseif (x>t1+t2 and x<=t1+t2+t3)
						then
						return 1-(x-t1-t2)/t3
						else
							return 0 
							end
							end,T,i*dur_real/max_n2)
		local para=_G.interpolate_color(para_t,color1,color2)
		tag_out[#tag_out+1]=tag..para
	end
	return tag_out,duration
end
	

function num_single(origin,count)--number，浮点数处理
   if origin==0
   then
   num_out=0
   else
   	if count
   		then
   local d,float=math.modf(origin)
   local float=math.abs(float*(10^count))
   num_out=d+math.abs(origin)/origin*(math.floor(float+0.5)/(10^count))
else
	num_out=math.floor(origin+0.5)
end
   end
   return num_out
end

function num(origin,count)
	if type(origin)=="number" and (type(count)=="number" or (not count))
		then
		return num_single(origin,count)
	elseif type(origin)=="table" and type(count)=="table"
		then
		local tbl={}
		assert(#origin==#count,"the length of origin data has to be equal to the length of count")
		for i=1,#origin
			do
			tbl[i]=num_single(origin[i],count[i])
		end
		return tbl
	elseif type(origin)=="table" and type(count)=="number"
		then
		local tbl={}
		for i=1,#origin
			do
			tbl[i]=num_single(origin[i],count)
		end
		return tbl
	else
		error("incorrect input!!")
	end
end

function text_to_shape(name,size,text,x_off,y_off,clip_x_off,clip_y_off,b)--string，文字矢量化简化
	local shape0=_G.Yutils.decode.create_font(name,b,false,false,false,size).text_to_shape(text)
	clip=string.format("\\clip(%s)",_G.shape.translate(shape0,clip_x_off,clip_y_off))
	if (not (x_off and y_off))
		then
		return shape0,clip
    else
		return _G.shape.translate(shape0,x_off,y_off),clip
    end
end		

function text2shape(style,text,x_off,y_off,clip_x_off,clip_y_off)
	x_off=(x_off and x_off or 0)
	y_off=(y_off and y_off or 0)
	clip_x_off=(clip_x_off and clip_x_off or 0)
	clip_y_off=(clip_y_off and clip_y_off or 0)
	local shape0=_G.Yutils.decode.create_font(style.fontname,false,false,false,false,style.fontsize,style.xscale,style.yscale,style.hspace).text_to_shape(text)
	local clip=_G.shape.translate(shape0,clip_x_off,clip_y_off)
	return _G.shape.translate(shape0,x_off,y_off),clip
end		

function text_to_pixels(name,size,text,x_off,y_off,outline)--table，文字像素化(最后的参数为true时将边框像素化，否则将文字本身像素化)
 	local shape0=_G.Yutils.decode.create_font(name,false,false,false,false,size).text_to_shape(text)
 	if outline 
 		then
 		local flatten=_G.Yutils.shape.flatten(shape0)
 		local outline=_G.shape.translate(_G.Yutils.shape.to_outline(flatten,1),x_off,y_off)
		pos=_G.Yutils.shape.to_pixels(outline)
 	else
		pos=_G.Yutils.shape.to_pixels(_G.shape.translate(shape0,x_off,y_off)) 
	end
	return pos
end

function img(width,height,mode,name,x_off,y_off,path)
	path=(path and path or "")
	x_off=(x_off and x_off or 0)
	y_off=(y_off and y_off or 0)
	return string.format("\\%dimg(%s.png,%d,%d)",mode,path..name,x_off,y_off),shape.rect(-width/2,-height/2,width,height)
end

function table.mix(tbl)--table，打乱集合元素
	for i=1,#tbl
		do
		local var=math.random(#tbl)
		tbl[i],tbl[var]=tbl[var],tbl[i]
	end
	return tbl
end

function table.add(tbl1,tbl2)--table，合并集合元素
	for i=1,#tbl2
		do
		tbl1[#tbl1+1]=table.copy_deep(tbl2[i])
	end
	return tbl1
end

function table.sample(tbl,n,mode)
	local new_tbl={}
	if mode=="c"
		then
		for i=1,n
			do
			new_tbl[i]=tbl[i]
		end
		return new_tbl
	elseif mode=="d"
		then
		for i=1,#tbl,n
			do
			new_tbl[#new_tbl+1]=tbl[i]
		end
		return new_tbl
	end
end

function ergodic_rand(min,max,integral)--table，产生遍历随机数(离散值)
	local rand={}
	if (not integral)
		then for i=1,max-min+1
		do rand[#rand+1]=min+i-1
	end
	for i=1,#rand
		do
		local var=math.random(#rand)
		rand[i],rand[var]=rand[var],rand[i]
	end
else
	for i=1,max-min+1
		do rand[#rand+1]=min+i-1+math.random()
	end
	for i=1,#rand
		do
		local var=math.random(#rand)
		rand[i],rand[var]=rand[var],rand[i]
	end
end
return rand
end

function shape.positive_edge(n,center,middle,R,theta)--string，正多边形
	theta=(theta and theta or 0)
	local err="wrong input to function:Kshape.positive_edge(edge_n,x0,y0,R,theta)\n"
	kbug(err,n,"edge_n","number")
	kbug(err,center,"x0","number")
	kbug(err,middle,"y0","number")
	kbug(err,R,"R","number")
	kbug(err,theta,"theta","number")
	local str=""
	for i=1,n 
		do
		str=str..string.format("%s %d %d ",i==1 and "m" or "l",num(center+R*math.cos(math.rad(theta)+(i-1)*2*math.pi/n),0),num(middle-R*math.sin(math.rad(theta)+(i-1)*2*math.pi/n),0))
	end
	return str
end

function shape.positive_edge_dou(n,center,middle,R1,R2,theta)--string，凹多边形
	theta=(theta and theta or 0)
	local err="wrong input to function:Kshape.star(edge_n,x0,y0,R1,R2,theta)\n"
	kbug(err,n,"edge_n","number")
	kbug(err,center,"x0","number")
	kbug(err,middle,"y0","number")
	kbug(err,R1,"R1","number")
	kbug(err,R2,"R2","number")
	kbug(err,theta,"theta","number")
	local str=""
	local n=n*2
	for i=1,n
		do
		str=str..string.format("%s %d %d ",i==1 and "m" or "l",num(center+(i%2==1 and R1 or R2)*math.cos(math.rad(theta)+(i-1)*2*math.pi/n),0),num(middle-(i%2==1 and R1 or R2)*math.sin(math.rad(theta)+(i-1)*2*math.pi/n),0))
	end
	return str
end

function shape.round(x0,y0,R)--string，近圆
	local err="wrong input to function:Kshape.round(x0,y0,R)\n"
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,R,"R","number")
	local a=4*R*(math.sqrt(2)-1)/3
	return string.format("m %d %d b %d %d %d %d %d %d b %d %d %d %d %d %d b %d %d %d %d %d %d b %d %d %d %d %d %d",x0-R,y0,x0-R,y0-a,x0-a,y0-R,x0,y0-R,x0+a,y0-R,x0+R,y0-a,x0+R,y0,x0+R,y0+a,x0+a,y0+R,x0,y0+R,x0-a,y0+R,x0-R,y0+a,x0-R,y0)
end

function shape.half_round(x0,y0,R)--string，近半圆
	local err="wrong input to function:Kshape.half_round(x0,y0,R)\n"
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,R,"R","number")
	local a=4*R*(math.sqrt(2)-1)/3
	return string.format("m %d %d b %d %d %d %d %d %d b %d %d %d %d %d %d ",x0-R,y0,x0-R,y0-a,x0-a,y0-R,x0,y0-R,x0+a,y0-R,x0+R,y0-a,x0+R,y0)
end

function shape.ring(x0,y0,R1,R2)--string，近圆环
	local r1,r2=shape.round(x0,y0,R1),shape.round(x0,y0,R2)
	return r1.." "..shape.reverse(r2).." "
end

function shape.half_ring(x0,y0,R1,R2)--string，近半圆环
	local r1,r2=shape.half_round(x0,y0,R1),string.gsub(shape.reverse(shape.half_round(x0,y0,R2)),"[m(%s)(%d)(%s)(%d)]+","",1)
	return r1.."l "..(R2+x0).." "..y0.." "..r2
end

function shape.positive_ring(edge_n,x0,y0,R1,R2,theta)
	theta=(theta and theta or 0)
	local err="wrong input to function:Kshape.positive_ring(edge_n,x0,y0,R1,R2,theta)\n"
	kbug(err,edge_n,"edge_n","number")
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,R1,"R1","number")
	kbug(err,R2,"R2","number")
	kbug(err,theta,"theta","number")
	local s1=shape.positive_edge(edge_n,x0,y0,R1,theta)
	local s2=shape.reverse(shape.positive_edge(edge_n,x0,y0,R2,theta))
	return s1..s2.." "
end

function shape.polygon(edge_n,x0,y0,a,b,theta1,theta2)
	theta1=(theta1 and theta1 or 0)
	theta2=(theta2 and theta2 or 0)
	local str=""
	for i=1,edge_n
		do
		local tx,ty=num(x0+a*math.cos(i*math.pi*2/edge_n+math.pi/2+math.rad(theta1))),num(y0+b*math.sin(i*math.pi*2/edge_n+math.pi/2+math.rad(theta1)))
		str=str..(i==1 and "m " or "l ")..tx.." "..ty.." "
	end
	return _G.Kshape.rotate(str,theta2)
end

--以下为拆字相关函数

function point_cut(str,mod_str)--table，按模式截取字符串(不包含模式字符串本身)
	local k,cut=0,{} 
	local len=_G.unicode.len(str)
	local out={}
	for s in _G.unicode.chars(str) 
		do 
		k=k+1
		if s==mod_str
		then 
		cut[#cut+1]=k
		end
		end
	if k==0 then out[1]=str
	else 
		for i=1,#cut
		do 
		out[#out+1]=string.sub(str,cut[i]+1,i==#cut and len or cut[i+1]-1)
		end
	end
		return out
end

function get_pos(ass_shape)
	local err="wrong input to function:Kshape.get_pos(ass_shape)\n"
	kbug(err,ass_shape,"ass_shape","string")
	if ass_shape==""
		then
		return {x={0},y={0}}
	else
		local pos={x={},y={}}
		for x,y in string.gmatch(ass_shape,"(-?[%d.]+) (-?[%d.]+)")
			do
			pos.x[#pos.x+1]=tonumber(x)
			pos.y[#pos.y+1]=tonumber(y)
		end
		return pos
	end
end

function green(tbl)--number，格林公式
	local sum=0
	for i=1,#tbl.x
		do
		sum=sum+(tbl.y[math.fmod(i-1,#tbl.y)+1]+tbl.y[math.fmod(i,#tbl.y)+1])*(tbl.x[math.fmod(i,#tbl.x)+1]-tbl.x[math.fmod(i-1,#tbl.x)+1])/2-(tbl.x[math.fmod(i-1,#tbl.x)+1]+tbl.x[math.fmod(i,#tbl.x)+1])*(tbl.y[math.fmod(i,#tbl.y)+1]-tbl.y[math.fmod(i-1,#tbl.y)+1])/2
	end
	return math.abs(sum),(sum<0 and true or false)
end

function poly(num_tbl1,num_tbl2)--table，多项式积各项系数计算
	local num_out={}
	for i=1,#num_tbl1+#num_tbl2-1
		do
		num_out[#num_out+1]=0
	end 
	for i=1,#num_tbl1 
		do 
			for p=1,#num_tbl2 
				do 
					num_out[i+p-1]=num_out[i+p-1]+num_tbl1[i]*num_tbl2[p]
			end
	end
	return num_out
end

function poly_pow(c_tbl,n_tbl,n)--table,table，二项式展开系数计算
	if #c_tbl~=#n_tbl
		then
		_G.error("多项式项数与系数数量不对应")
	else
	local new_n={}
	local new_c=c_tbl
	if (n==0)
		then
		new_c,new_n={1},{0}
	elseif (n<0)
		then
		_G.error("次数不能为负数")
		elseif(num(n)~=n)
			then
			_G.error("次数不能为浮点数")
			else
	for i=1,n-1
		do
		new_c=poly(new_c,c_tbl)
	end
	for i=1,#new_c
		do
		new_n[i]=#new_c-i
	end
end
	return new_c,new_n
end
end

function difi_inte_xn(c_tbl,n_tbl,a,b)--number，多项式定积分
	local sum=0
	if #c_tbl~=#n_tbl
		then
			_G.error("the length of c_tbl must be equal to the length of n_tbl\n")
		else
		for i=1,#n_tbl
			do
			if n_tbl[i]==-1
			then
				temp_sum=c_tbl[i]*(math.log(math.abs(b))-math.log(math.abs(a)))
			else
				temp_sum=c_tbl[i]*(math.pow(b,n_tbl[i]+1)-math.pow(a,n_tbl[i]+1))/(n_tbl[i]+1)
			end 
			sum=sum+temp_sum
		end
	end
	return sum
end

function table.num_add(tbl1,tbl2)--table，将两个数组的元素相加并返回新数组
	local new_tbl={}
	if (type(tbl1)~="table" or type(tbl1)~="table")
		then
		error("tbl1 and tbl2 must be table value")
	end
	if (#tbl1>#tbl2)
		then
		error("tbl1长度大于tbl2长度")
	elseif(#tbl1<#tbl2)
		then
		error("tbl2长度大于tbl1长度"..string.format("：差为%d",#tbl2-#tbl1))
	else
	for i=1,#tbl1
		do
		new_tbl[#new_tbl+1]=tbl1[i]+tbl2[i]
	end
	return new_tbl
end
end

function table.num_multi(tbl,num)--table，将数组的元素数乘num并返回新数组
	local new_tbl={}
	for i=1,#tbl
		do
		new_tbl[i]=tbl[i]*num
	end
	return new_tbl
end

function bezier_coe_count(tbl)--table,table，贝塞尔曲线参数方程多项式系数计算
	local n=#tbl
	local c_tbl={}
	local n_tbl={}
	local c_tbl_single={}
	for i=0,n-1
		do
		c_tbl[i+1]=0
		c_tbl_single[i+1]=table.num_multi(poly(poly_pow({1,0},{1,0},i),poly_pow({-1,1},{1,0},n-i-1)),tbl[i+1]*combin(n-1,i))
		n_tbl[i+1]=n-1-i
	end
	for p=1,#c_tbl_single
		do
		c_tbl=table.num_add(c_tbl,c_tbl_single[p])
	end
	return c_tbl,n_tbl
end

function der_poly(c_tbl,n_tbl)--table,talbe，多项式求导
	local new_c,new_n={},{}
	for i=1,#c_tbl
		do
		new_c[#new_c+1]=c_tbl[i]*n_tbl[i]
		new_n[#new_n+1]=(n_tbl[i]==0 and 0 or n_tbl[i]-1)
	end
	return new_c,new_n
end

function bezier_curve_integral_2_test(x1,y1,x2,y2,x3,y3,x4,y4)--number，三次贝塞尔曲线第二型线积分
	local n_tbl={3,2,1,0}
	local n_mul_tbl={5,4,3,2,1,0}
	local c_x_tbl=bezier_coe_count({x1,x2,x3,x4})
	local c_y_tbl=bezier_coe_count({y1,y2,y3,y4})
	local der_x=der_poly(c_x_tbl,n_tbl)
	local der_y=der_poly(c_y_tbl,n_tbl)
	_G.table.remove(der_x)
	_G.table.remove(der_y)
	local ydx=difi_inte_xn(poly(der_x,c_y_tbl),n_mul_tbl,0,1)
	local xdy=difi_inte_xn(poly(der_y,c_x_tbl),n_mul_tbl,0,1)
	return xdy/2-ydx/2
end

function bezier_curve_integral_2_test21(x0,y0,x1,y1,x2,y2,x3,y3)--number，三次贝塞尔曲线第二型线积分
	local X2=9*x1+3*x3-9*x2-3*x0
	local X1=6*x0-12*x1+6*x2
	local X0=3*x1-3*x0
	local Y3=3*y1+y3-3*y2-y0
	local Y2=3*y0-6*y1+3*y2
	local Y1=3*y1-3*y0
	local Y0=y0
	return (X2*Y3/6+(X2*Y2+X1*Y3)/5+(X2*Y1+X1*Y2+X0*Y3)/4+(X0*Y2+Y1*X1+Y0*X2)/3+(X1*Y0+X0*Y1)/2+X0*Y0)
end

function bezier_curve_integral_2_test2(x0,y0,x1,y1,x2,y2,x3,y3)
	local xdy=bezier_curve_integral_2_test21(y0,x0,y1,x1,y2,x2,y3,x3)
	local ydx=bezier_curve_integral_2_test21(x0,y0,x1,y1,x2,y2,x3,y3) 
	return (xdy-ydx)/2
end

function bezier_curve_integral_2(x1,y1,x2,y2,x3,y3,x4,y4)--number，三次贝塞尔曲线第二型线积分
	local tbl1={}
	local tbl2={}
	tbl1[1],tbl1[2],tbl1[3],tbl1[4]=x1-3*x2+3*x3-x4,3*x2-6*x3+3*x4,3*x3-3*x4,x4
	tbl2[1],tbl2[2],tbl2[3]=3*(y1-3*y2+3*y3-y4),2*(3*y2-6*y3+3*y4),3*y3-3*y4
	local c_tbl=poly(tbl1,tbl2)
	n_tbl={}
	for i=1,6
		do 
		n_tbl[#n_tbl+1]=6-i
	end
	return difi_inte_xn(c_tbl,n_tbl,0,1)
end

function integral_2(vector1,vector2)
 	if (_G.type(vector1)~="string" or _G.type(vector2)~="string")
 		then
 		_G.error("vector is not a string value")
 	else
 	local pos1,pos2=get_pos(vector1),get_pos(vector2)
 	local s_x,s_y=pos1.x[#pos1.x],pos1.y[#pos1.y]
 	if #pos2.x==1
 		then
 		local e_x,e_y=pos2.x[#pos2.x],pos2.y[#pos2.y]
 		integral=(s_x+e_x)*(e_y-s_y)/4-(s_y+e_y)*(e_x-s_x)/4
 	else
 		integral=bezier_curve_integral_2_test2(s_x,s_y,pos2.x[1],pos2.y[1],pos2.x[2],pos2.y[2],pos2.x[3],pos2.y[3])
 	end
 	return integral
end
end

function shape.close_single(ass_shape)
	local lx,ly=string.match(ass_shape,"(-?[%d.]+) (-?[%d.]+) *$")
	local sx,sy=string.match(ass_shape,"(-?[%d.]+) (-?[%d.]+)")
	sx,sy=tonumber(sx),tonumber(sy)
	lx,ly=tonumber(lx),tonumber(ly)
	if (not(sx==lx and sy==ly))
		then
		ass_shape=ass_shape.."l "..sx.." "..sy.." "
		return ass_shape
	else
		return ass_shape
	end
end

function shape.close(ass_shape)
	local err="wrong input to function:Kshape.close(ass_shape)\n"
	kbug(err,ass_shape,"ass_shape","string")
	local str=""
	for s in string.gmatch(ass_shape,"[m][^m]+")
		do
		str=str..shape.close_single(s)
	end
	return str
end

function shape.open(ass_shape)
	local err="wrong input to function:Kshape.open(ass_shape)\n"
	kbug(err,ass_shape,"ass_shape","string")
	local str=""
	for s in ass_shape:gmatch("m[^m]+")
		do
		local sx,sy=string.match(s,"(-?[%d.]+) (-?[%d.]+)")
		local ex,ey=string.match(s,"(-?[%d.]+) (-?[%d.]+) *$")
		local cmd=string.match(string.match(s,"[a-z][^a-z]+$"),"[a-z]")
		if cmd=="l" and sx==ex and ey==sy
			then
			s=s:gsub("[a-z][^a-z]+$","")
		end
		str=str..s
	end
	return str
end

function shape.measure(ass_shape)--number,boolean，图形面积计算(绝对值)
	local err="wrong input to function:Kshape.measure(ass_shape)\n"
	kbug(err,ass_shape,"ass_shape","string")
	local sum=0 
	local vector={}
	if ass_shape==""
		then sum=0
	else
	for s in string.gmatch(ass_shape,"[a-z] [^a-z]+")
		do 
		vector[#vector+1]=s
	end
	for i=1,#vector
		do
		sum=sum+integral_2(vector[i],vector[math.fmod(i,#vector)+1])
	end
end
	return math.abs(sum),(sum<0 and true or false)
end

function shape.measure_text(ass_shape)
	local err="wrong input to function:Kshape.measure_text(ass_shape)\n"
	kbug(err,ass_shape,"ass_shape","string")
	local part={}
	for s in string.gmatch(ass_shape,"m[^m]+")
		do
		part[#part+1]=s
	end
	for i=1,#part
		do
		if i==1
			then
			mea0,jud0=_G.shape.measure(part[i])
		else
			mea,jud=_G.shape.measure(part[i])
			if jud==jud0
				then
				mea0=mea0+mea
			else
				mea0=mea0-mea
			end
		end
	end
	return math.abs(mea0)
end

function direction(shape)--boolean,table,table，判断绘图方向并归类
	local clock={}
	local anti_clock={}
	sum={anti,clock_s}
	sum.anti,sum.clock_s=0,0
	local mod=""
	out=point_cut(shape,"m")
	for i=1,#out
		do 
		out[i]="m"..out[i]
	end
	for i=1,#out
		do
		local cover,jud=_G.shape.measure(out[i])
		if jud
		then
			anti_clock[#anti_clock+1]={shape=out[i],measure=cover,include=true,org=out[i]}
			sum.anti=(#anti_clock==1 and cover or sum.anti+cover)
		else
			clock[#clock+1]={shape=out[i],measure=cover,include=true,org=out[i]}
			sum.clock_s=(#clock==1 and cover or sum.clock_s+cover)
		end
	end
	table.sort(clock,function(a,b) return a.measure<b.measure end)
	table.sort(anti_clock,function(a,b) return a.measure<b.measure end)
	if sum.anti<sum.clock_s
		then
		return clock,anti_clock
	else
		return anti_clock,clock
	end
end

function shape.single_point_detect(ass_shape)
	local part={}
	for s in string.gmatch(ass_shape,"[m] [^m]+")
		do
		local pos=get_pos(s)
		if #pos.x~=1
			then
		part[#part+1]=s
	end
	end
	return table.concat(part)
end

function shape.is_include(shape1,shape2)
	local pos={}
	local k=0
	for s in string.gmatch(shape2,"[a-z][^a-z]+")
		do
		local pos0=get_pos(s)
		pos[#pos+1]={x=pos0.x[#pos0.x],y=pos0.y[#pos0.y]}
	end
	for i=1,#pos
		do
		if _G.shape.contains_point(shape1,pos[i].x,pos[i].y)
			then
			k=k+1
		end
	end
	return k>=1
end

function assemble(shape,mode)--table，绘图组合，还原镂空部分
	local anti,clock=direction(shape)
	local shape_out={}
	for i=1,#anti
		do
		for p=1,#clock
			do
			if clock[p].include
				then
				local sx,sy=string.match(clock[p].shape,"(-?[%d.]+) (-?[%d.]+)")
				sx,sy=tonumber(sx),tonumber(sy)
				if _G.shape.is_include(anti[i].org,clock[p].shape)
					then
					anti[i].shape=anti[i].shape..clock[p].shape
					clock[p].include=false
				end
			end
		end
	end
	for i=1,#anti
		do
		local x,y,s=_G.shape.bounding_an(anti[i].shape,mode)
		shape_out[#shape_out+1]={x=x,y=y,shape=s}
	end
	return shape_out
end

--以上为拆字相关函数

function shape.filter(ass_shape,filter)
	local function t_filter(x,y)
		local nx,ny=filter(tonumber(x),tonumber(y))
		return ""..num(nx,3).." "..num(ny,3)
	end
	local str=gsub(ass_shape,"(-?[%d.]+) (-?[%d.]+)",t_filter)
	return str
end

function shape.filter_m(ass_shape,filter)
	local s=gsub(ass_shape,"([m][^a-z]+)",
		function(str)
			local str1=shape.filter(str,filter)
			return str1
		end
		)
	return s
end

function shape.filter_l(ass_shape,filter)
	local s=gsub(ass_shape,"([l][^a-z]+)",
		function(str)
			local str1=shape.filter(str,filter)
			return str1
		end
		)
	return s
end

function shape.filter_b(ass_shape,filter)
	local s=gsub(ass_shape,"([b][^a-z]+)",
		function(str)
			local str1=shape.filter(str,filter)
			return str1
		end
		)
	return s
end

function shape.filter_mode(ass_shape,filter,mode)
	local err="wrong input to function:Kshape.filter(ass_shape,filter,mode)\n"
	local s_filter={m=shape.filter_m,l=shape.filter_l,b=shape.filter_b}
	mode=(mode and mode or "mlb")
	kbug(err,ass_shape,"ass_shape","string")
	kbug(err,filter,"filter","function")
	kbug(err,mode,"mode","string")
	mode=string.lower(mode)
	assert(string.match(mode,"[mlb]"),"wrong input to function:shape.filter_mode(ass_shape,filter,mode)\nmode has to include \"m\" or \"l\" or \"b\"")
	local t1,t2,t3=string.match(mode,"m"),string.match(mode,"l"),string.match(mode,"b")
	if t1
		then
		ass_shape=s_filter[t1](ass_shape,filter)
	end
	if t2
		then
		ass_shape=s_filter[t2](ass_shape,filter)
	end
	if t3
		then
		ass_shape=s_filter[t3](ass_shape,filter)
	end
	return ass_shape
end

Kshape={}

Kshape.rect=function(x,y,w,h)
	local err="wrong input to function:Kshape.rect(x,y,w,h)\n"
	kbug(err,x,"x","number")
	kbug(err,y,"y","number")
	kbug(err,w,"w","number")
	kbug(err,h,"h","number")
	return string.format("m %d %d l %d %d l %d %d l %d %d l %d %d ",x,y,x+w,y,x+w,y+h,x,y+h,x,y)
end

Kshape.triangle=function(x1,y1,x2,y2,x3,y3)
	local err="wrong input to function:Kshape.triangle(x1,y1,x2,y2,x3,y3)\n"
	kbug(err,x1,"x1","number")
	kbug(err,y1,"y1","number")
	kbug(err,x2,"x2","number")
	kbug(err,y2,"y2","number")
	kbug(err,x3,"x3","number")
	kbug(err,y3,"y3","number")
	return string.format("m %d %d l %d %d l %d %d l %d %d ",x1,y1,x2,y2,x3,y3,x1,y1)
end

Kshape.scale=function(ass_shape,sx,sy,x0,y0)
	local err="wrong input to function:Kshape.scale(ass_shape,sx,sy,x0,y0)\n"
	sx=(sx and sx or 1)
	sy=(sy and sy or 1)
	x0=(x0 and x0 or 0)
	y0=(y0 and y0 or 0)
	kbug(err,ass_shape,"ass_shape","string")
	kbug(err,sx,"sx","number")
	kbug(err,sy,"sy","number")
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	return shape.filter(ass_shape,function(x,y) return num(x+(sx-1)*(x-x0)),num(y+(sy-1)*(y-y0)) end)
end

Kshape.move=function(ass_shape,tx,ty)
	local err="wrong input to function:Kshape.move(ass_shape,tx,ty)\n"
	tx=(tx and tx or 0)
	ty=(ty and ty or 0)
	kbug(err,ass_shape,"ass_shape","string")
	kbug(err,tx,"tx","number")
	kbug(err,ty,"ty","number")
	return shape.filter(ass_shape,function(x,y) return x+tx,y+ty end)
end

Kshape.rotate=function(ass_shape,theta,x0,y0)
	local err="wrong input to function:Kshape.rotate(ass_shape,theta,x0,y0)\n"
	theta=(theta and theta or 0)
	x0=(x0 and x0 or 0)
	y0=(y0 and y0 or 0)
	kbug(err,ass_shape,"ass_shape","string")
	kbug(err,theta,"theta","number")
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	rad0=math.rad(theta)
	return shape.filter(ass_shape,function(x,y) return num((x-x0)*math.cos(rad0)+x0+(y-y0)*math.sin(rad0)),num((y-y0)*math.cos(rad0)+y0-(x-x0)*math.sin(rad0)) end)
end

Kshape.shear=function (ass_shape,sx,sy)
	local err="wrong input to function:Kshape.shear(ass_shape,sx,sy)\n"
	sx=(sx and sx or 0)
	sy=(sy and sy or 0)
	kbug(err,ass_shape,"ass_shape","string")
	kbug(err,sx,"sx","number")
	kbug(err,sy,"sy","number")
	return shape.filter(ass_shape,function(x,y) return num(x+y*sx),num(y+x*sy) end)
end

Kshape.text_split=function(ass_shape)
	local err="wrong input to function:Kshape.text_split(ass_shape)\n"
	kbug(err,ass_shape,"ass_shape","string")
	return assemble(ass_shape)
end

Kshape.pixels=function(ass_shape)
	local pixels={}
	assert(type(ass_shape)=="string","ass_shape has to be a string value")
	local vec={}
	ass_shape=(string.match(ass_shape,"b") and _G.shape.flat(ass_shape) or ass_shape)
	local x1,y1,x2,y2=shape.bounding_real(ass_shape)
	local function get_vec(ass_shape)
		local vec={}
		for s in string.gmatch(ass_shape,"[a-z][^a-z]+")
			do
			local pos=get_pos(s)
			vec[#vec+1]={str=s,sx,sy,ex=pos.x[1],ey=pos.y[1]}
		end
		for i=2,#vec+1
			do
			local ir=(i-1)%#vec+1
			local pos=get_pos(vec[i-1].str)
			vec[ir].sx,vec[ir].sy=pos.x[1],pos.y[1]
		end
		return vec
	end
	for s in string.gmatch(ass_shape,"[m][^m]+")
		do
		vec=table.add(vec,get_vec(s))
	end
	table.sort(vec,function(a,b) return math.min(a.sy,a.ey)<math.min(b.sy,b.ey) end)
	local function get_point(vector,sy)
		local pos={}
		local xpos={}
		for i=1,#vector
			do
			if (vector[i].ey~=vector[i].sy and math.max(vector[i].ey,vector[i].sy)>=sy and sy>=math.min(vector[i].ey,vector[i].sy) )
				then
				if sy>=math.min(vector[i].sy,vector[i].ey)
					then
					local jy=num((vector[i].sy-sy)*(vector[i].ey-sy))
					if jy<0 or (jy==0 and sy==math.min(vector[i].sy,vector[i].ey))
						then
						local t=(sy-vector[i].sy)/(vector[i].ey-vector[i].sy)
						local t1=(sy-1-vector[i].sy)/(vector[i].ey-vector[i].sy)
						local ix=vector[i].sx*(1-t)+vector[i].ex*t
						local ix1=vector[i].sx*(1-t1)+vector[i].ex*t
						local a1,a2=math.ceil(ix)-ix,math.ceil(ix1)-ix1
						local b1,b2=ix-math.floor(ix),ix1-math.floor(ix1)
						local s1,s2=(a1+a2)/2,(b1+b2)/2
						xpos[#xpos+1]={x=ix,s1=s1,s2=s2}
					end
				else
					break
				end
			end
		end
		table.sort(xpos,function(a,b) return a.x<b.x end)
		for i=1,#xpos,2
			do
			local sx,ex=xpos[i].x,xpos[i+1].x
			local l=math.ceil(ex)-math.floor(sx)
			for p=0,l
				do
				local alpha=(p==0 and sx-math.floor(sx) or (p==l) and math.ceil(ex)-ex or 1)
				pos[#pos+1]={x=(p==0 and sx or (p==l) and ex or p+math.floor(sx)),y=sy,alpha=string.format("&H%.2X&",255-255*alpha)}
			end
		end
		return pos
	end
	for i=y1,y2
		do
		local pos0=table.copy_deep(get_point(vec,i))
		pixels=table.add(pixels,pos0)
	end
	return pixels
end

--以下为生成Delaunay三角网相关函数(枚举)

function shape.triangle(x1,y1,x2,y2,x3,y3)--string，生成三角形绘图
	local vec_x1,vec_y1,vec_x2,vec_y2=x2-x1,y2-y1,x3-x2,y3-y2
	if vec_x1*vec_y2-vec_x2*vec_y1==0
		then
		return false
	else
	return "m "..x1.." "..y1.." l "..x2.." "..y2.." l "..x3.." "..y3.." "
	end
end

function slope(x1,y1,x2,y2)--number,number，计算两点连线斜率和纵截距
	if x1~=x2
		then
		return (y2-y1)/(x2-x1),y1-x1*(y2-y1)/(x2-x1)
	else
		return false,x1
	end
end

function bisector(x1,y1,x2,y2)--number,number，计算两点连线的中垂线的斜率和纵截距
	if y2~=y1
		then 
		return (x1-x2)/(y2-y1),(y1+y2)/2-(x1/2+x2/2)*(x1-x2)/(y2-y1)
	else
		return false,(x1+x2)/2
	end
end

function line_intersection(k1,b1,k2,b2)--number,number，计算两直线交点
	if k1==false
		then
		return b1,k2*b1+b2
	elseif k2==false
		then
		return b2,k1*b2+b1
	elseif k1==k2
		then
		return false
	else
		return (b2-b1)/(k1-k2),k1*(b2-b1)/(k1-k2)+b1
	end
end

function circle_rxy(ass_shape)--table，计算多边形外接圆半径以及圆心坐标
	local cir={r,x,y}
	if type(ass_shape)~="string"
		then
		_G.aegisub.debug.out("ass_shape must be a string value\n")
	else
	posget=get_pos(ass_shape)
	if #posget.x<=2
		then _G.aegisub.debug.out("there must be enough points to be counted\n")
	else
		local k1,b1=bisector(posget.x[1],posget.y[1],posget.x[2],posget.y[2])
		local k2,b2=bisector(posget.x[2],posget.y[2],posget.x[3],posget.y[3])
		cir.x,cir.y=line_intersection(k1,b1,k2,b2)
		cir.r=math.sqrt(math.pow(cir.x-posget.x[1],2)+math.pow(cir.y-posget.y[1],2))
	end
end
	return cir
end

function circle_rxy_inner(ass_shape)
	local pos=get_pos(ass_shape)
	local x0,y0,x1,y1,x2,y2=pos.x[1],pos.y[1],pos.x[2],pos.y[2],pos.x[3],pos.y[3]
	local a=math.distance(x1-x2,y1-y2)
	local b=math.distance(x2-x0,y2-y0)
	local c=math.distance(x1-x0,y1-y0)
	local s=a+b+c
	if s==0
		then
		return 0,0
	else
		local ix,iy=(a*x0+b*x1+c*x2)/s,(a*y0+b*y1+c*y2)/s
		return ix,iy
	end
end

function table.delete(tbl)--table，删除点集内相同元素
	local newtbl={}
	for i=1,#tbl-1
		do
		for p=i+1,#tbl
			do
			if ((tbl[i].x>tbl[p].x) or (tbl[i].x==tbl[p].x and tbl[i].y>tbl[p].y))
				then
				tbl[i],tbl[p]=tbl[p],tbl[i]
			end
		end
	end
	newtbl[1]=tbl[1]
	for i=2,#tbl
		do
		if (not(tbl[i].x==tbl[i-1].x and tbl[i].y==tbl[i-1].y))
			then
			newtbl[#newtbl+1]=tbl[i]
		end
	end
	return newtbl
end

--function table.delete(tbl)
	--local k_del={}
	--for i=1,#tbl.x-1
		--do
		--for p=i+1,#tbl.x
			--do
			--if (tbl.x[p]==tbl.x[i] and tbl.y[p]==tbl.y[i])
			--	then 
			--	k_del[#k_del+1]=p
			--end
	--	end
--	end
		--for i=1,#k_del
			--do
			--_G.table.remove(tbl.x,k_del[i]-i+1)
			--_G.table.remove(tbl.y,k_del[i]-i+1)
		--end
		--return tbl
	--end

function shape.get_pos(ass_shape)--table，获取图形坐标
	local num={}
	local pos={}
	local out=point_cut(ass_shape," ")
	for i=1,#out
		do
		num[#num+1]=tonumber(out[i])
	end
	for i=1,#num/2
		do
		pos[i]={x=num[2*i-1],y=num[2*i]}
	end
	return pos
end

function get_edge(ass_shape)--table，获取图形边信息
	local edge={}
	local pos=_G.shape.get_pos(ass_shape)
	for i=1,#pos+1
		do
		edge[i]={s={x=pos[i].x,y=pos[i].y},e={x=pos[math.fmod(i,#pos)+1].x,y=pos[math.fmod(i,#pos)+1].y}}
	end
	return edge
end

function super_tri(point)--string，生成超级三角形
	for i=1,#points
		do
		max_x=math.max((i==1 and point[i].x or max_x),point[i].x)
		max_y=math.max((i==1 and point[i].y or max_y),point[i].y)
		min_x=math.min((i==1 and point[i].x or min_x),point[i].x)
		min_y=math.min((i==1 and point[i].y or min_y),point[i].y)
	end
	return string.format("m %d %d l %d %d l %d %d ",2*min_x-max_x,min_y-8,2*max_x-min_x,min_y-8,(min_x+max_x)/2,2*max_y-min_y+8)
end

function delau_1(point)
	local edge_buffer={}--初始化边集合
	local temp_tri={}--初始化temp triangle集合
	local tri={}--初始化triangle集合
	local super={shape,pos}
	super.shape=super_tri(point)
	super.pos=_G.shape.get_pos(super.shape)
	--point=_G.table.add(point,super.pos)
	for i=1,#point
		do
		p=1
	end
	return ""
end

function tri_cir_judge(tri1,tri2)
	local cir1,cir2=circle_rxy(tri1),circle_rxy(tri2)
	if (math.pow(cir1.x-cir2.x,2)+math.pow(cir1.y-cir2.y,2))<math.pow(cir1.r,2)
		then
		return false
	else
		return true
	end
end

function tri_point_judge(tri,x,y)
	local cir=circle_rxy(tri)
	if num((math.pow(cir.x-x,2)+math.pow(cir.y-y,2))+0.5,1)<math.pow(cir.r,2)
		then
		return false
	else
		return true
	end
end 

function delau(min_x,max_x,min_y,max_y,max_n,ctrl_n,mode)
	local out_tri={}
	local k_del=0
	local tri_del={}
	local temp_tri={}
	local rand={}
	for i=1,max_n
		do
		rand[#rand+1]={x=math.random(min_x,max_x),y=math.random(min_y,max_y)}
	end
	for i=1,math.sqrt(ctrl_n)
		do
		for p=1,math.sqrt(ctrl_n)
			do rand[#rand+1]={x=min_x+(max_x-min_x)*(i-1)/(math.sqrt(ctrl_n)-1),y=min_y+(max_y-min_y)*(p-1)/(math.sqrt(ctrl_n)-1)}
		end
	end
	rand=_G.table.delete(rand)
	for i=1,#rand-2
		do
		for p=i+1,#rand-1
			do
			for q=p+1,#rand
				do
				if _G.shape.triangle(rand[i].x,rand[i].y,rand[p].x,rand[p].y,rand[q].x,rand[q].y)
					then
						temp_tri[#temp_tri+1]=_G.shape.triangle(rand[i].x,rand[i].y,rand[p].x,rand[p].y,rand[q].x,rand[q].y)
				end
			end
		end
	end
	for i=1,#temp_tri
		do
		for p=1,#rand
			do
			if (not tri_point_judge(temp_tri[i],rand[p].x,rand[p].y))
				then 
				tri_del[#tri_del+1]=i
				break
			end
		end
	end
	for i=1,#tri_del
		do 
		_G.table.remove(temp_tri,tri_del[i]-i+1)
	end
	for i=1,#temp_tri do 
		out_tri[#out_tri+1]={}
		local x1,y1,x2,y2=_G.shape.bounding(temp_tri[i])
		out_tri[i].x,out_tri[i].y=(x1+x2)/2,(y1+y2)/2
		out_tri[i].shape=_G.shape.translate(temp_tri[i],-(x1+x2)/2,-(y1+y2)/2)
	end
	return (mode=="origin_pos" and temp_tri or out_tri)
end

function delau_point(point,mode)
	local out_tri={}
	local k_del=0
	local tri_del={}
	local temp_tri={}
	local rand=_G.table.delete(point)
	for i=1,#rand-2
		do
		for p=i+1,#rand-1
			do
			for q=p+1,#rand
				do
				if _G.shape.triangle(rand[i].x,rand[i].y,rand[p].x,rand[p].y,rand[q].x,rand[q].y)
					then
						temp_tri[#temp_tri+1]=_G.shape.triangle(rand[i].x,rand[i].y,rand[p].x,rand[p].y,rand[q].x,rand[q].y)
				end
			end
		end
	end
	for i=1,#temp_tri
		do
		for p=1,#rand
			do
			if (not tri_point_judge(temp_tri[i],rand[p].x,rand[p].y))
				then 
				tri_del[#tri_del+1]=i
				break
			end
		end
	end
	for i=1,#tri_del
		do 
		_G.table.remove(temp_tri,tri_del[i]-i+1)
	end
	for i=1,#temp_tri do 
		out_tri[#out_tri+1]={}
		local x1,y1,x2,y2=_G.shape.bounding_real(temp_tri[i])
		out_tri[i].x,out_tri[i].y=(x1+x2)/2,(y1+y2)/2
		out_tri[i].shape=_G.shape.translate(temp_tri[i],-(x1+x2)/2,-(y1+y2)/2)
	end
	return (mode=="origin_pos" and temp_tri or out_tri)
end

function empty_check(tbl)
	local del_k={}
	for i=1,#tbl
		do
		if (tbl[i]=="" or tbl[i]=="m 0 0")
			then del_k[#del_k+1]=i
		end
	end
	for i=1,#del_k
		do
		_G.table.remove(tbl,del_k[i]-i+1)
	end
	return tbl
end

function shape.get_command(ass_shape)--table，获取绘图指令(字符串，坐标)
	local vec={}
	for s in string.gmatch(ass_shape,"[a-z] [^a-z]+")
		do
		vec[#vec+1]={}
		vec[#vec].str=s
		local pos=get_pos(s)
		vec[#vec].x,vec[#vec].y={},{}
		for i=1,#pos.x
			do
			vec[#vec].x[#vec[#vec].x+1]=pos.x[i]
			vec[#vec].y[#vec[#vec].y+1]=pos.y[i]
		end
	end
	return vec
end

function line_split(vec,max_len,x0,y0)--string，将直线按设置线段长度分割
	local x1,y1=vec.x[#vec.x],vec.y[#vec.y]
	if string.match(vec.str,"l")~=nil
		then
		local len=math.sqrt(math.pow(x1-x0,2)+math.pow(y1-y0,2))
		local n=math.floor(len/max_len)
		if n==0
			then
			new_vec=vec.str
		else
		for i=1,n 
			do
			new_vec=(i==1 and "" or new_vec)..string.format("l %d %d ",x0+(x1-x0)*i/n,y0+(y1-y0)*i/n)
		end
	end
else
	new_vec=vec.str
end
return new_vec
end

function shape.split_test_single(ass_shape,max_len)--string，将图形中的直线按设置线段长度分割为直线
	local vector=_G.shape.get_command(ass_shape)
	local new_shape=vector[1].str
	for i=1,#vector
		do
		vector[i].str=line_split(vector[math.fmod(i,#vector)+1],max_len,vector[i].x[#vector[i].x],vector[i].y[#vector[i].y])
		new_shape=new_shape..vector[i].str
	end
	return new_shape
end

function shape.split_test(ass_shape,max_len)
	local str=""
	for s in string.gmatch(ass_shape,"[m][^m]+")
		do
		str=str..shape.split_test_single(s,max_len)
	end
	return str
end

function shape.split_curvi(ass_shape,max_len)--string，将图形中的直线按设置线段长度分割为贝塞尔曲线
	return _G.shape.curvi(_G.shape.split_test(ass_shape,max_len))
end

function shape.curvi(ass_shape)
	local err="wrong input to function:Kshape.curvi(ass_shape)\n"
	kbug(err,ass_shape,"ass_shape","string")
	local function to_bezier(str)
		local pos=get_pos(str)
		local x,y=pos.x[1],pos.y[1]
		return "b "..string.rep(tostring(x).." "..tostring(y).." ",3)
	end
	return string.gsub(ass_shape,"[l][^a-z]+",function(str) return to_bezier(str) end)
end

function bezier_split(sx,sy,vec,t,count)--贝塞尔曲线分割
	local pos=get_pos(vec)
	local x1,x2,x3=table.unpack(pos.x)
	local y1,y2,y3=table.unpack(pos.y)
	table.insert(pos.x,1,sx)
	table.insert(pos.y,1,sy)
	local x0,y0=sx,sy
	local ex,ey=bezier_position(pos.x,pos.y,t)
	local A={x=x0,y=y0}
	local B={x=x1,y=y1}
	local C={x=x2,y=y2}
	local D={x=x3,y=y3}
	local E={x=ex,y=ey}
	local F={x=A.x*(1-t)+B.x*t,y=A.y*(1-t)+B.y*t}
	local G={x=B.x*(1-t)+C.x*t,y=B.y*(1-t)+C.y*t}
	local H={x=C.x*(1-t)+D.x*t,y=C.y*(1-t)+D.y*t}
	local I={x=F.x*(1-t)+G.x*t,y=F.y*(1-t)+G.y*t}
	local J={x=G.x*(1-t)+H.x*t,y=G.y*(1-t)+H.y*t}
	local str1="b "..F.x.." "..F.y.." "..I.x.." "..I.y.." "..E.x.." "..E.y.." "
	local str2="b "..J.x.." "..J.y.." "..H.x.." "..H.y.." "..D.x.." "..D.y.." "
	return shape.filter(str1,function(x,y) return num(x,count),num(y,count) end),shape.filter(str2,function(x,y) return num(x,count),num(y,count) end)
end

function bezier_split_multi(vec,sx,sy,tbl)
	local str=""
	local pos=get_pos(vec)
	table.insert(pos.x,1,sx)
	table.insert(pos.y,1,sy)
	for i=1,#tbl
		do
		local pct=(i==1 and tbl[i] or (tbl[i]-tbl[i-1])*100/(100-tbl[i-1]))
		local t=bezier_n_t_at_percent(pos.x,pos.y,pct)
		local s1,s2=bezier_split(sx,sy,vec,t,3)
		pos=get_pos(s2)
		str=str..s1
		vec=s2
		sx,sy=string.match(str,"([-.%d]+) ([-.%d]+) *$")
		sx,sy=tonumber(sx),tonumber(sy)
		table.insert(pos.x,1,sx)
		table.insert(pos.y,1,sy)
	end
	return str
end

function shape.get_vec(ass_shape)
	local tbl={}
	for s in ass_shape:gmatch("m[^m]+")
		do
		local ex,ey=s:match("([-%d.]+) ([-%d.]+) *$")
		local svec=s:match("m[^a-z]+")
		tbl[#tbl+1]={sx=ex,sy=ey,str=svec}
		while(true)
			do
			local x,y,str=s:match("([-%d.]+) ([-%d.]+) ([a-z][^a-z]+)")
			s=s:gsub("[a-z][^a-z]+","",1)
			if x and y and str
				then
				tbl[#tbl+1]={sx=x,sy=y,str=str}
			else
				break
			end
		end
	end
	return tbl
end

function Kshape.split(ass_shape,max_len)
	local err="wrong input to function:Kshape.split(ass_shape,max_len)\n"
	kbug(err,ass_shape,"ass_shape","string")
	kbug(err,max_len,"max_len","number")
	ass_shape=shape.close(shape.simplify(ass_shape))
	local function single(ass_shape,max_len)
		vec=shape.get_vec(ass_shape)
		for i=2,#vec+1
			do
			local ir=((i-1)%#vec)+1
			vec[ir].len=get_command_length("l "..vec[ir].sx.." "..vec[ir].sy.." ",vec[ir].str)
		end
		local out=vec[1].str
		for i=2,#vec
			do
			if string.match(vec[i].str,"b")
				then
				local tbl={}
				local max=math.floor(vec[i].len/max_len)
				for p=1,max
					do
					tbl[#tbl+1]=num(p*100*max_len/vec[i].len)
				end
				if tbl[#tbl]~=100
					then
					tbl[#tbl+1]=100
				end
				vec[i].str=shape.filter(bezier_split_multi(vec[i].str,vec[i].sx,vec[i].sy,tbl),function(x,y) return num(x),num(y) end)
			else
				local max=math.floor(vec[i].len/max_len)
				local pos1=get_pos(vec[i].str)
				local ex,ey=pos1.x[1],pos1.y[1]
				local sx,sy=vec[i].sx,vec[i].sy
				local str=""
				for p=1,max
					do
					local t=p*max_len/vec[i].len
					local tx,ty=(1-t)*sx+ex*t,(1-t)*sy+ey*t
					str=str.."l "..num(tx).." "..num(ty).." "
				end
				if max*max_len<vec[i].len
					then
					str=str.."l "..ex.." "..ey.." "
				end
				vec[i].str=str
			end
			out=out..vec[i].str
		end
		return out
	end
	local str=""
	for s in string.gmatch(ass_shape,"m[^m]+")
		do
		str=str..single(s,max_len)
	end
	return str
end

function shape.arc_single(x0,y0,r,start_theta,end_theta)
	local theta0=end_theta-start_theta
	local s_rad=math.rad(start_theta)
	local e_rad=math.rad(end_theta)
	local d_rad=math.rad(theta0)
	local sx,sy=num(x0+r*math.cos(s_rad)),num(y0-r*math.sin(s_rad))
	local ex,ey=num(x0+r*math.cos(e_rad)),num(y0-r*math.sin(e_rad))
	local x1=sx-(4/3)*((1-math.cos(d_rad/2))/math.sin(d_rad/2))*r*math.sin(s_rad)
	local y1=sy-(4/3)*((1-math.cos(d_rad/2))/math.sin(d_rad/2))*r*math.cos(s_rad)
	local x2=ex+(4/3)*((1-math.cos(d_rad/2))/math.sin(d_rad/2))*r*math.sin(e_rad)
	local y2=ey+(4/3)*((1-math.cos(d_rad/2))/math.sin(d_rad/2))*r*math.cos(e_rad)
	x1,y1,x2,y2=num(x1),num(y1),num(x2),num(y2)
	local str="b "..x1.." "..y1.." "..x2.." "..y2.." "..ex.." "..ey.." "
	return str
end

function shape.ellipse_arc_single(x0,y0,a,b,start_theta,end_theta)
	local theta0=end_theta-start_theta
	local s_rad=math.rad(start_theta)
	local e_rad=math.rad(end_theta)
	local d_rad=math.rad(theta0)
	local sx,sy=num(x0+a*math.cos(s_rad)),num(y0-b*math.sin(s_rad))
	local ex,ey=num(x0+a*math.cos(e_rad)),num(y0-b*math.sin(e_rad))
	local x1=sx-(4/3)*((1-math.cos(d_rad/2))/math.sin(d_rad/2))*a*math.sin(s_rad)
	local y1=sy-(4/3)*((1-math.cos(d_rad/2))/math.sin(d_rad/2))*b*math.cos(s_rad)
	local x2=ex+(4/3)*((1-math.cos(d_rad/2))/math.sin(d_rad/2))*a*math.sin(e_rad)
	local y2=ey+(4/3)*((1-math.cos(d_rad/2))/math.sin(d_rad/2))*b*math.cos(e_rad)
	x1,y1,x2,y2=num(x1),num(y1),num(x2),num(y2)
	local str="b "..x1.." "..y1.." "..x2.." "..y2.." "..ex.." "..ey.." "
	return str
end

function shape.arc(x0,y0,r,start_theta,end_theta,mode)--圆弧
	mode=(mode and mode or "")
	local err="wrong input to function:Kshape.arc(x0,y0,r,start_theta,end_theta,mode)\n"
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,r,"r","number")
	kbug(err,start_theta,"start_theta","number")
	kbug(err,end_theta,"end_theta","number")
	kbug(err,mode,"mode","string")
	local s_rad=math.rad(start_theta)
	local sx,sy=num(x0+r*math.cos(s_rad)),num(y0-r*math.sin(s_rad))
	local str=(mode=="shape" and "m "..sx.." "..sy.." " or "")
	local n=math.ceil(num(math.abs((end_theta-start_theta)),4)/90)
	local sig=math.sign(end_theta-start_theta)
	local func=(sig==1 and math.min or math.max)
	for i=1,n
		do
		str=str..shape.arc_single(x0,y0,r,start_theta+sig*(i-1)*90,func(start_theta+(sig*i)*90,end_theta))
	end
	return str
end

function shape.ellipse_arc(x0,y0,a,b,start_theta,end_theta,mode)--椭圆弧
	mode=(mode and mode or "")
	local err="wrong input to function:Kshape.ellipse_arc(x0,y0,a,b,start_theta,end_theta,mode)\n"
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,a,"a","number")
	kbug(err,b,"b","number")
	kbug(err,start_theta,"start_theta","number")
	kbug(err,end_theta,"end_theta","number")
	kbug(err,mode,"mode","string")
	local s_rad=math.rad(start_theta)
	local sx,sy=num(x0+a*math.cos(s_rad)),num(y0-b*math.sin(s_rad))
	local str=(mode=="shape" and "m "..sx.." "..sy.." " or "")
	local n=math.ceil(num(math.abs((end_theta-start_theta)),4)/90)
	local sig=math.sign(end_theta-start_theta)
	local func=(sig==1 and math.min or math.max)
	for i=1,n
		do
		str=str..shape.ellipse_arc_single(x0,y0,a,b,start_theta+sig*(i-1)*90,func(start_theta+(sig*i)*90,end_theta))
	end
	return str
end

function shape.arc_ring(x0,y0,r1,r2,start_theta,end_theta,start_style,end_style)--任意角度圆环
	local err="wrong input to function:Kshape.arc_ring(x0,y0,r1,r2,start_theta,end_theta,start_style,end_style)\n"
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,r1,"r1","number")
	kbug(err,r2,"r2","number")
	kbug(err,start_theta,"start_theta","number")
	kbug(err,end_theta,"end_theta","number")
	local s_rad=math.rad(start_theta)
	local e_rad=math.rad(end_theta)
	local str1=shape.arc(x0,y0,r1,start_theta,end_theta,"shape")
	local str2=shape.arc(x0,y0,r2,end_theta,start_theta)
	local x1,y1=num(x0+r2*math.cos(e_rad)),num(y0-r2*math.sin(e_rad))
	local x2,y2=num(x0+r1*math.cos(s_rad)),num(y0-r1*math.sin(s_rad))
	if start_style
		then
		local tx,ty=num(x0+((r1+r2)/2)*math.cos(s_rad)),num(y0-((r1+r2)/2)*math.sin(s_rad))
		if r1>r2
			then
			s_str=shape.arc(tx,ty,math.abs(r1-r2)/2,start_theta-math.sign(end_theta-start_theta)*180,start_theta)
		else
			s_str=shape.arc(tx,ty,math.abs(r1-r2)/2,start_theta,start_theta-math.sign(end_theta-start_theta)*180)
		end
	else
		s_str="l "..x2.." "..y2.." "
	end
	if end_style
		then
		local tx,ty=num(x0+((r1+r2)/2)*math.cos(e_rad)),num(y0-((r1+r2)/2)*math.sin(e_rad))
		if r1>r2
			then
			e_str=shape.arc(tx,ty,math.abs(r1-r2)/2,end_theta,end_theta+math.sign(end_theta-start_theta)*180)
		else
			e_str=shape.arc(tx,ty,math.abs(r1-r2)/2,end_theta+math.sign(end_theta-start_theta)*180,end_theta)
		end
	else
		e_str="l "..x1.." "..y1.." "
	end
	return str1..e_str..str2..s_str
end

function shape.ellipse_arc_ring(x0,y0,a1,b1,a2,b2,start_theta,end_theta,start_style,end_style)--任意角度椭圆环
	local err="wrong input to function:Kshape.ellipse_arc_ring(x0,y0,a1,b1,a2,b2,start_theta,end_theta)\n"
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,a1,"a1","number")
	kbug(err,a2,"a2","number")
	kbug(err,b1,"b1","number")
	kbug(err,b2,"b2","number")
	kbug(err,start_theta,"start_theta","number")
	kbug(err,end_theta,"end_theta","number")
	local s_rad=math.rad(start_theta)
	local e_rad=math.rad(end_theta)
	local str1=shape.ellipse_arc(x0,y0,a1,b1,start_theta,end_theta,"shape")
	local str2=shape.ellipse_arc(x0,y0,a2,b2,end_theta,start_theta)
	local x1,y1=num(x0+a2*math.cos(e_rad)),num(y0-b2*math.sin(e_rad))
	local x2,y2=num(x0+a1*math.cos(s_rad)),num(y0-b1*math.sin(s_rad))
	if start_style
		then
		local tx,ty=num(x0+((a1+a2)/2)*math.cos(s_rad)),num(y0-((b1+b2)/2)*math.sin(s_rad))
		if a1>a2
			then
			s_str=shape.ellipse_arc(tx,ty,math.abs(a1-a2)/2,math.abs(b1-b2)/2,start_theta-math.sign(end_theta-start_theta)*180,start_theta)
		else
			s_str=shape.ellipse_arc(tx,ty,math.abs(a1-a2)/2,math.abs(b1-b2)/2,start_theta,start_theta-math.sign(end_theta-start_theta)*180)
		end
	else
		s_str="l "..x2.." "..y2.." "
	end
	if end_style
		then
		local tx,ty=num(x0+((a1+a2)/2)*math.cos(e_rad)),num(y0-((b1+b2)/2)*math.sin(e_rad))
		if a1>a2
			then
			e_str=shape.ellipse_arc(tx,ty,math.abs(a1-a2)/2,math.abs(b1-b2)/2,end_theta,end_theta+math.sign(end_theta-start_theta)*180)
		else
			e_str=shape.ellipse_arc(tx,ty,math.abs(a1-a2)/2,math.abs(b1-b2)/2,end_theta+math.sign(end_theta-start_theta)*180,end_theta)
		end
	else
		e_str="l "..x1.." "..y1.." "
	end
	return str1..e_str..str2..s_str
end
	
function shape.sector(x0,y0,r,start_theta,end_theta)--扇形
	local err="wrong input to function:Kshape.sector(x0,y0,r,start_theta,end_theta)\n"
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,r,"r","number")
	kbug(err,start_theta,"start_theta","number")
	kbug(err,end_theta,"end_theta","number")
	local s_rad=math.rad(start_theta)
	local sx,sy=num(x0+r*math.cos(s_rad)),num(y0-r*math.sin(s_rad)) 
	local str="m "..x0.." "..y0.." l "..sx.." "..sy.." "
	local arc=shape.arc(x0,y0,r,start_theta,end_theta)
	str=str..arc.."l "..x0.." "..y0.." "
	return str
end

function shape.ellipse_sector(x0,y0,a,b,start_theta,end_theta)--椭圆扇形
	local err="wrong input to function:Kshape.ellipse_sector(x0,y0,a,b,start_theta,end_theta)\n"
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,a,"a","number")
	kbug(err,b,"b","number")
	kbug(err,start_theta,"start_theta","number")
	kbug(err,end_theta,"end_theta","number")
	local s_rad=math.rad(start_theta)
	local sx,sy=num(x0+a*math.cos(s_rad)),num(y0-b*math.sin(s_rad)) 
	local str="m "..x0.." "..y0.." l "..sx.." "..sy.." "
	local arc=shape.ellipse_arc(x0,y0,a,b,start_theta,end_theta)
	str=str..arc.."l "..x0.." "..y0.." "
	return str
end

function shape.screw_half(x0,y0,r,dr,width,start_theta,n)--螺旋环
	dr=-dr
	local str=""
	local e_theta=start_theta+n*180
	local e_rad=math.rad(e_theta)
	for i=1,n
		do
		str=str..shape.arc(x0+(i%2==1 and 0 or -dr),y0,r-(i-1)*dr,(i-1)*180,i*180,(i==1 and "shape" or ""))
	end
	local w=width
	str=str.."l "..num(x0+(r-(n-(n%2))*dr+w)*math.cos((n%2)*math.pi)).." "..num(y0+(r-(n-1)*dr+w)*math.sin((n%2)*math.pi)).." "
	for i=n,1,-1
		do
		str=str..shape.arc(x0+(i%2==1 and 0 or -dr),y0,r-(i-1)*dr+math.abs(width),i*180,(i-1)*180)
	end
	return Kshape.rotate(str,start_theta)
end

function shape.screw(x0,y0,r,dr,width,start_theta,end_theta,d_theta,start_style,end_style)
	local err="wrong input to function:Kshape.screw(x0,y0,r,dr,width,start_theta,end_theta,d_theta,start_style,end_style)\n"
	kbug(err,x0,"x0","number")
	kbug(err,y0,"x0","number")
	kbug(err,r,"r","number")
	kbug(err,dr,"dr","number")
	kbug(err,width,"width","number")
	kbug(err,start_theta,"start_theta","number")
	kbug(err,end_theta,"end_theta","number")
	kbug(err,d_theta,"d_theta","number")
	assert(end_theta-start_theta>=0,err.."end_theta has to be greater than start_theta")
	local the=end_theta-start_theta
	local str=""
	local max=math.floor(the/d_theta)
	local tbl={}
	if max>=1
		then
		tbl[1]={s=start_theta,e=start_theta+d_theta,r1=r,r2=r+width,x=x0,y=y0}
		for i=2,max
			do
			local ex,ey=tbl[i-1].x+tbl[i-1].r1*math.cos(math.rad(tbl[i-1].e)),tbl[i-1].y-tbl[i-1].r1*math.sin(math.rad(tbl[i-1].e))
			tbl[#tbl+1]={s=start_theta+(i-1)*d_theta,e=start_theta+i*d_theta,r1=r+(i-1)*dr,r2=r+width+(i-1)*dr}
			local x,y=ex-tbl[i].r1*math.cos(math.rad(tbl[i].s)),ey+tbl[i].r1*math.sin(math.rad(tbl[i].s))
			tbl[i].x,tbl[i].y=num(x,3),num(y,3)
		end
		local the_e=num(end_theta-(max*d_theta+start_theta),1)
		if the_e~=0
			then
			local ex,ey=tbl[max].x+tbl[max].r1*math.cos(math.rad(tbl[max].e)),tbl[max].y-tbl[max].r1*math.sin(math.rad(tbl[max].e))
			tbl[#tbl+1]={s=tbl[max].e,e=end_theta,r1=tbl[max].r1+dr,r2=tbl[max].r1+dr+width}
			local x,y=ex-tbl[max+1].r1*math.cos(math.rad(tbl[max+1].s)),ey+tbl[max+1].r1*math.sin(math.rad(tbl[max+1].s))
			tbl[max+1].x,tbl[max+1].y=num(x,3),num(y,3)
		end
		local x,y=x0,y0
		for i=1,#tbl
			do
			str=str..shape.arc(tbl[i].x,tbl[i].y,tbl[i].r1,tbl[i].s,tbl[i].e,(i==1 and "shape" or ""))
		end
		local ex,ey=string.match(str,"([-.%d]+) ([-.%d]+) *$")
		x,y=ex-(r+#tbl*dr-dr)*math.cos(math.rad(end_theta)),ey+(r+#tbl*dr-dr)*math.sin(math.rad(end_theta))
		local tx,ty=x+(r+#tbl*dr+width-dr)*math.cos(math.rad(end_theta)),y-(r+#tbl*dr+width-dr)*math.sin(math.rad(end_theta))
		if end_style
			then
			local tx1,ty1=(ex+tx)/2,(ey+ty)/2
			e_str=shape.arc(tx1,ty1,width/2,end_theta+math.sign(end_theta-start_theta)*180,end_theta)
			str=str..e_str
		else
			str=str.."l "..num(tx).." "..num(ty).." "
		end
		for i=#tbl,1,-1
			do
			str=str..shape.arc(tbl[i].x,tbl[i].y,tbl[i].r2,tbl[i].e,tbl[i].s)
		end
		if start_style
			then
			local tx1,ty1=x0+(r+width/2)*math.cos(math.rad(start_theta)),y0-(r+width/2)*math.sin(math.rad(start_theta))
			e_str=shape.arc(tx1,ty1,width/2,start_theta,start_theta-math.sign(end_theta-start_theta)*180)
			str=str..e_str
		end
	else
		tbl={r1=r,r2=r+width,x=x0,y=y0}
		str=shape.arc_ring(tbl.x,tbl.y,tbl.r1,tbl.r1+width,start_theta,end_theta,start_style,end_style)
	end
	return str
end

function shape.fillet_polygon(edge_n,x0,y0,r1,r2,theta)
	local str=""
	local a=90-180/edge_n
	local a_rad=math.rad(a)
	local r=r1-r2/math.sin(a_rad)
	for i=1,edge_n
		do
		local x0,y0=r*math.cos((i-1)*math.pi*2/edge_n),-r*math.sin((i-1)*math.pi*2/edge_n)
		local s,e=(i-1)*360/edge_n-90+a,(i-1)*360/edge_n+90-a
		local s1,e1=(i)*360/edge_n-90+a,(i)*360/edge_n+90-a
		local x1,y1=r*math.cos((i)*math.pi*2/edge_n),-r*math.sin((i)*math.pi*2/edge_n)
		local x,y=x1+r2*math.cos(math.rad(s1)),y1-r2*math.sin(math.rad(s1))
		str=str..shape.arc(x0,y0,r2,s,e,(i==1 and "shape" or "")).."l "..num(x).." "..num(y).." "
	end
	return Kshape.rotate(str,theta)
end

function shape.star_arc(vertex_n,x0,y0,r1,r2,width,pct,theta)
	local err="wrong input to function:shape.star_arc(vectex_n,x0,y0,r1,r2,width,pct,theta)\n"
	pct=(pct and pct or 100)
	theta=(theta and theta or 0)
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,vertex_n,"vertex_n","number")
	assert(vertex_n>=3,err.."vertex_n has to be greater than 2\n兄啊你怎么想搞低于三边的多边形啊")
	kbug(err,r1,"r1","number")
	kbug(err,r2,"r2","number")
	kbug(err,pct,"pct","number")
	kbug(err,width,"width","number")
	kbug(err,theta,"theta","number")
	r1,r2=math.max(r1,r2),math.min(r1,r2)
	local r3=math.sqrt(r1^2+r2^2-2*r1*r2*math.cos(math.pi/vertex_n))
	local rad_t=r2*math.sin(math.pi/vertex_n)/r3
	local r4=num(width/rad_t+r1)
	if pct~=100
		then
		local n=math.ceil(vertex_n*pct/100)
		local a,b=math.modf(pct*vertex_n/100)
		local nt=num(b,4)
		local str=""
		local tbl={}
		for i=1,vertex_n
			do
			local x2,y2=num(r2*math.cos((2*i-1)*math.pi/vertex_n)),num(-r2*math.sin((2*i-1)*math.pi/vertex_n))
			local x1,y1=num(r1*math.cos((2*i-2)*math.pi/vertex_n)),num(-r1*math.sin((2*i-2)*math.pi/vertex_n))
			local x3,y3=num(r1*math.cos((2*i)*math.pi/vertex_n)),num(-r1*math.sin((2*i)*math.pi/vertex_n))
			tbl[#tbl+1]={x1=x1,y1=y1,x2=x2,y2=y2,x3=x3,y3=y3}
		end
		for i=1,n
			do
			if i~=n
				then
				str=str..(i==1 and "m "..tbl[1].x1.." "..tbl[1].y1.." l " or "l ")..tbl[i].x2.." "..tbl[i].y2.." l "..tbl[i].x3.." "..tbl[i].y3.." "
			else
				if nt>0.5
					then
					local t=2*(nt-0.5)
					local tx,ty=(1-t)*tbl[i].x2+t*tbl[i].x3,(1-t)*tbl[i].y2+t*tbl[i].y3
					str=str..(i==1 and "m "..tbl[1].x1.." "..tbl[1].y1.." l " or "l ")..tbl[i].x2.." "..tbl[i].y2.." l "..num(tx).." "..num(ty).." "
				elseif nt>0 and nt<=0.5
					then
					local t=2*nt
					local tx,ty=(1-t)*tbl[i].x1+t*tbl[i].x2,(1-t)*tbl[i].y1+t*tbl[i].y2
					str=str..(i==1 and "m "..tbl[1].x1.." "..tbl[1].y1.." l " or "l ")..num(tx).." "..num(ty).." "
				elseif nt==0
					then
					str=str..(i==1 and "m "..tbl[1].x1.." "..tbl[1].y1.." l " or "l ")..tbl[i].x2.." "..tbl[i].y2.." l "..tbl[i].x3.." "..tbl[i].y3.." "
				end
			end
		end
		local str2=shape.reverse(Kshape.scale(str,r4/r1,r4/r1))
		return shape.filter(Kshape.rotate(str..str2:gsub("m","l",1),theta),function(x,y) return num(x+x0),num(y+y0) end)
	else
		local str1=shape.positive_edge_dou(vertex_n,0,0,r1,r2,theta)
		local str2=shape.reverse(Kshape.scale(str1,r4/r1,r4/r1))
		return shape.filter(str1..str2,function(x,y) return num(x+x0),num(y+y0) end)
	end
end

function shape.star_ring(vertex_n,x0,y0,r1,r2,width,theta)
	local err="wrong input to function:shape.star_ring(vertex_n,x0,y0,r1,r2,width,theta)\n"
	theta=(theta and theta or 0)
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,vertex_n,"vertex_n","number")
	assert(vertex_n>=3,err.."vertex_n has to be greater than 2")
	kbug(err,r1,"r1","number")
	kbug(err,r2,"r2","number")
	kbug(err,width,"width","number")
	kbug(err,theta,"theta","number")
	return shape.star_arc(vertex_n,x0,y0,r1,r2,width,100,theta)
end 

function shape.fillet_star(vertex_n,x0,y0,R1,R2,r1,r2,vertex_style1,vertex_style2,theta)
	local err="wrong input to function:Kshape.fillet_star(vertex_n,x0,y0,R1,R2,r1,r2,vertex_style1,vertex_style2,theta)\n"
	theta=(theta and theta or 0)
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,vertex_n,"vertex_n","number")
	kbug(err,r1,"r1","number")
	kbug(err,r2,"r2","number")
	kbug(err,R1,"R1","number")
	kbug(err,R2,"R2","number")
	kbug(err,theta,"theta","number")
	R1,R2=math.max(R1,R2),math.min(R1,R2)
	local at=180/vertex_n
	local ar=math.rad(at)
	local l=math.sqrt(R1^2+R2^2-2*R1*R2*math.cos(ar))
	local br=math.asin(R2*math.sin(ar)/l)
	local bt=math.deg(br)
	local ct=180-bt-at
	local cr=math.rad(ct)
	local dt=180-ct
	local dr=math.rad(dt)
	local r3=R1-r1/math.sin(br)
	local dt1=90-bt
	local r4=R2+r2/math.sin(dr)
	local dt2=90-dt
	local str=""
	for i=1,vertex_n
		do
		local s,e=(i-1)*360/vertex_n-dt1,(i-1)*360/vertex_n+dt1
		local x,y=r3*math.cos((i-1)*2*math.pi/vertex_n),-r3*math.sin((i-1)*2*math.pi/vertex_n)
		local s1,e1=(2*i-1)*180/vertex_n+180+dt2,(2*i-1)*180/vertex_n+180-dt2
		local x1,y1=r4*math.cos((2*i-1)*math.pi/vertex_n),-r4*math.sin((2*i-1)*math.pi/vertex_n)
		local str1=shape.arc(x,y,r1,s,e,(i==1 and "shape" or ""))
		local str2=shape.arc(x1,y1,r2,s1,e1)
		if vertex_style1
			then
			str=str..str1
		else
			str=str..(i==1 and "m " or "l ")..num(R1*math.cos((i-1)*math.pi*2/vertex_n)).." "..num(-R1*math.sin((i-1)*math.pi*2/vertex_n)).." "
		end
		local x2,y2=r3*math.cos((i)*2*math.pi/vertex_n),-r3*math.sin((i)*2*math.pi/vertex_n)
		local s2,e2=(i)*360/vertex_n-dt1,(i)*360/vertex_n+dt1
		local l_s="l "..num(x2+r1*math.cos(math.rad(s2))).." "..num(y2-r1*math.sin(math.rad(s2))).." "
		if vertex_style2
			then
			str=str.."l "..num(x1+r2*math.cos(math.rad(s1))).." "..num(y1-r2*math.sin(math.rad(s1))).." "..str2..l_s
		else
			str=str.."l "..num(R2*math.cos((2*i-1)*math.pi/vertex_n)).." "..num(-R2*math.sin((2*i-1)*math.pi/vertex_n)).." "..l_s
		end
	end
	return shape.filter(Kshape.rotate(str,theta),function (x,y) return num(x+x0),num(y+y0) end)
end

function shape.flower(f_n,x0,y0,R,r,mode)
	local err="wrong input to function:Kshape.flower(f_n,x0,y0,R,r,mode)\n"
	mode=(mode and mode or "s")
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,f_n,"f_n","number")
	kbug(err,R,"R","number")
	kbug(err,r,"r","number")
	kbug(err,mode,"mode","string")
	assert(mode=="s" or mode=="g","wrong input to function:shape.flower(f_n,x0,y0,R,r,mode)\nmode only supports \"s\" and \"g\" ")
	local str=""
	local sig=(mode=="g" and 1 or -1)
	local a=R*math.sin(math.rad(180/f_n))
	assert(a<=r,"wrong input to function:shape.flower(f_n,x0,y0,R,r,mode)\nr has to be greater than a:a-r="..(a-r))
	local the=math.deg(math.asin(a/r))
	local t_rad=math.rad(the)
	local r1=R*math.cos(math.rad(180/f_n))+r*sig*math.cos(t_rad)
	local dt=(mode=="g" and 180-the or the)
	for i=1,f_n
		do
		local x,y=x0+r1*math.cos((i-1)*math.pi*2/f_n),y0-r1*math.sin((i-1)*math.pi*2/f_n)
		local s,e=(i-1)*360/f_n-dt,(i-1)*360/f_n+dt
		str=str..shape.arc(x,y,r,s,e,(i==1 and "shape" or ""))
	end
	return str
end

function shape.curvi_polygon(edge_n,x0,y0,R,r,mode)
	mode=(mode and mode or "s")
	local str=""
	local t_rad=math.asin(R*math.sin(math.rad(180/edge_n))/r)
	local the=math.deg(t_rad)
	local r1=r*math.cos(t_rad)+R*math.cos(math.pi/edge_n)
	local dt=(mode=="s" and the or 180-the)
	local x,y=x0+r1,y0
	local s,e=180+dt,180-dt
	local str2=shape.arc(x,y,r,s,e)
	str=str..shape.arc(x,y,r,s,e,"shape")
	for i=2,edge_n
		do
		str=str..Kshape.rotate(str2,(i-1)*360/edge_n,x0,y0)
	end
	return str
end

function shape.kasa(edge_n,x0,y0,R,r,mode)
	mode=(mode and mode or "s")
	local str=""
	local t_rad=math.asin(R*math.sin(math.rad(180/edge_n))/r)
	local the=math.deg(t_rad)
	local r1=r*math.cos(t_rad)+R*math.cos(math.pi/edge_n)
	local dt=(mode=="s" and the or 180-the)
	local x,y=x0+r1,y0
	local s,e=180+dt,180-dt
	local str2=shape.arc(x,y,r,s,e)
	str=str..shape.arc(x,y,r,s,e,"shape")
	local x,y=str:match("([-.%d]+) ([-.%d]+)")
	str2="m "..x0.." "..y0.." l "..x.." "..y.." "..str2.."l "..x0.." "..y0.." "
	return str2
end

function shape.flower_arc(f_n,x0,y0,R1,R2,r,pct,mode)
	mode=(mode and mode or "s")
	local err="wrong input to function:Kshape.flower_arc(f_n,x0,y0,R1,R2,r,pct,mode)\n"
	mode=(mode and mode or "s")
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,f_n,"f_n","number")
	kbug(err,R1,"R1","number")
	kbug(err,R2,"R2","number")
	kbug(err,r,"r","number")
	kbug(err,pct,"pct","number")
	kbug(err,mode,"mode","string")
	assert(mode=="s" or mode=="g","wrong input to function:shape.flower_arc(f_n,x0,y0,R,r,pct,mode)\nmode only supports \"s\" and \"g\" ")
	local str=""
	local sig=(mode=="g" and 1 or -1)
	local a=R1*math.sin(math.rad(180/f_n))
	assert(a<=r,"wrong input to function:shape.flower_arc(f_n,x0,y0,R,r,pct,mode)\nr has to be greater than a:a-r="..(a-r))
	local the=math.deg(math.asin(a/r))
	local t_rad=math.rad(the)
	local r1=R1*math.cos(math.rad(180/f_n))+r*sig*math.cos(t_rad)
	local dt=(mode=="g" and 180-the or the)
	n1=math.floor(pct*f_n/100)
	et=num(pct*360/100-n1*360/f_n,1)
	t=et/(360/f_n)
	for i=1,n1
		do
		local x,y=r1*math.cos((i-1)*math.pi*2/f_n),-r1*math.sin((i-1)*math.pi*2/f_n)
		local s,e=(i-1)*360/f_n-dt,(i-1)*360/f_n+dt
		str=str..shape.arc(x,y,r,s,e,(i==1 and "shape" or ""))
	end
	if et>0
		then
		local x,y=r1*math.cos(n1*math.pi*2/f_n),-r1*math.sin(n1*math.pi*2/f_n)
		local s,e=n1*360/f_n-dt,n1*360/f_n-dt+2*dt*t
		str=str..shape.arc(x,y,r,s,e,(n1>=1 and "" or "shape"))
	end
	local str2=shape.reverse(Kshape.scale(str,R2/R1,R2/R1))
	local sx,sy=str2:match("([-.%d]+) ([-.%d]+)")
	str=str.."l "..sx.." "..sy.." "..str2:gsub("m[^a-z]+",1)
	return shape.filter(str,function (x,y) return num(x+x0),num(y+y0) end)
end

function shape.positive_arc(edge_n,x0,y0,r1,r2,pct)
	pct=(pct and pct or 100)
	local err="wrong input to function:Kshape.positive_arc(edge_n,x0,y0,r1,r2,pct)\n"
	kbug(err,pct,"pct","number")
	pct=num(pct,2)
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,edge_n,"edge_n","number")
	kbug(err,r1,"r1","number")
	kbug(err,r2,"r2","number")
	if pct==100
		then
		return shape.positive_ring(edge_n,x0,y0,r1,r2,0)
	else
		local a=2*r1*math.sin(math.rad(180/edge_n))
		local str="m "..num(r1).." 0 "
		local the=360*pct/100
		local theta=360/edge_n
		local max=math.floor(the/theta)
		local t=(pct*edge_n*a/100-max*a)/a
		local e_the=math.fmod(the,theta)
		for i=1,max
			do
			local x,y=r1*math.cos(i*math.pi*2/edge_n),-r1*math.sin(i*math.pi*2/edge_n)
			str=str.."l "..num(x).." "..num(y).." "
		end
		if num(e_the,1)~=0
			then
			local sx,sy=r1*math.cos(max*math.pi*2/edge_n),-r1*math.sin(max*math.pi*2/edge_n)
			local ex,ey=r1*math.cos((max+1)*math.pi*2/edge_n),-r1*math.sin((max+1)*math.pi*2/edge_n)
			local tx,ty=ex*t+sx*(1-t),ey*t+sy*(1-t)
			str=str.."l "..num(tx).." "..num(ty).." "
		end
		local str2=shape.reverse(Kshape.scale(str,r2/r1,r2/r1))
		local x1,y1=str2:match("([-.%d]+) ([-.%d]+)")
		str=str.."l "..x1.." "..y1.." "
		str=str..string.gsub(str2,"m[^a-z]+","",1)
		return shape.filter(str,function (x,y) return num(x+x0),num(y+y0) end)
	end
end

function shape.polygon_to_fillet(ass_shape,r,style1,style2)
	local err="wrong input to function:Kshape.polygon_to_fillet(ass_shape,r,style1,style2)\n"
	kbug(err,ass_shape,"ass_shape","string")
	assert((not string.match(ass_shape,"b")),err.."ass_shape can't include 'b' command")
	local function f_angle(x0,y0,x1,y1,x2,y2)
		local nx1,ny1=x0-x1,y0-y1
		local nx2,ny2=x2-x1,y2-y1
		local l1,l2=math.distance1(nx1,ny1),math.distance1(nx2,ny2)
		if l1==0 or l2==0
			then
			return 0
		else
			local op=nx1*nx2+ny1*ny2
			local r=op/(l1*l2)
			return math.deg(math.acos(r))
		end
	end

	local function to_range(theta)
		if math.abs(theta)<=180
			then
			return theta
		elseif theta>180
			then
			return to_range(theta-360)
		else
			return to_range(theta+360)
		end
	end

	local function to_fillet_single(ass_shape,r,style1,style2)
		local vec={}
		local str=""
		ass_shape=shape.close(ass_shape)
		local mea,jud=shape.measure(ass_shape)
		local k=0
		for s in ass_shape:gmatch("[a-z][^a-z]+")
			do
			k=k+1
			local pos=get_pos(s)
			vec[#vec+1]={str=s,x1=pos.x[1],y1=pos.y[1],x0,y0,con}
			if k>1
				then
				local spos=get_pos(vec[k-1].str)
				local sx,sy=spos.x[1],spos.y[1]
				vec[k].x0,vec[k].y0=sx,sy
			end
		end
		table.remove(vec,1)
		local out=""
		for i=2,#vec+1
			do
			local ir=(i-1)%#vec+1
			local x0,y0=vec[i-1].x0,vec[i-1].y0
			local x1,y1=vec[i-1].x1,vec[i-1].y1
			local x2,y2=vec[ir].x1,vec[ir].y1
			vec[i-1].x2,vec[i-1].y2=x2,y2
			vec[i-1].deg=f_angle(x0,y0,x1,y1,x2,y2)
			local deg1,deg2=f_angle(x0,y0,x1,y1,x1+10,y1),f_angle(x2,y2,x1,y1,x1+10,y1)
			if (y0-y1)*(y2-y1)>0
				then
				vec[i-1].deg1=math.sign(y2-y1)*(deg1+deg2)/2
			else
				if (x2-x1)*(x0-x1)>0
					then
					if y0-y1<0
						then
						deg1=((x0-x1)<0 and 360-deg1 or -deg1)
					end
					if y2-y1<0
						then
						deg2=((x0-x1)<0 and 360-deg2 or -deg2)
					end
					vec[i-1].deg1=to_range((deg1+deg2)/2)
				else
					if y0-y1<0
						then
						deg1=(360-deg1>180+deg2 and -deg1 or 360-deg1)
					end
					if y2-y1<0
						then
						deg2=(360-deg2>180+deg1 and -deg2 or 360-deg2)
					end
					vec[i-1].deg1=to_range((deg1+deg2)/2)
				end
			end
			local _,jud1=shape.measure(string.format("m %d %d l %d %d l %d %d ",x0,y0,x1,y1,x2,y2))
			if jud1==jud
				then
				vec[i-1].con=true
			else
				vec[i-1].con=false
			end
			if (style1 or style2)
				then
				local l=r/math.sin(math.rad(vec[i-1].deg/2))
				local x_t,y_t=vec[i-1].x1+l*math.cos(math.rad(vec[i-1].deg1)),vec[i-1].y1+l*math.sin(math.rad(vec[i-1].deg1))
				vec[i-1].x,vec[i-1].y=x_t,y_t
				local dt=90-vec[i-1].deg/2
				local s,e=180-vec[i-1].deg1-(jud1 and 1 or -1)*dt,180-vec[i-1].deg1+(jud1 and 1 or -1)*dt
				vec[i-1].s,vec[i-1].e=s,e
				if style1
					then
					if vec[i-1].con
						then
						local sx1,sy1=x_t+r*math.cos(math.rad(s)),y_t-r*math.sin(math.rad(s))
						local str="l "..num(sx1).." "..num(sy1).." "..shape.arc(x_t,y_t,r,s,e)
						vec[i-1].str=str
					end
				end
				if style2
					then
					if (not vec[i-1].con)
						then
						local sx,sy=x_t+r*math.cos(math.rad(s)),y_t-r*math.sin(math.rad(s))
						local str="l "..num(sx).." "..num(sy).." "..shape.arc(x_t,y_t,r,s,e)
						vec[i-1].str=str
					end
				end
			end
			out=out..vec[i-1].str
		end
		local ext,eyt=out:match("([-.%d]+) ([-%d.]+) *$")
		out="m "..ext.." "..eyt.." "..out
		return out
	end
	local out=""
	for s in string.gmatch(ass_shape,"m[^m]+")
		do
		out=out..to_fillet_single(s,r,style1,style2)
	end
	return out
end

function Kshape.ellipse(x0,y0,a,b)--椭圆
	local err="wrong input to fucntion:Kshape.ellipse(x0,y0,a,b)\n"
	kbug(err,x0,"x0","number")
	kbug(err,y0,"y0","number")
	kbug(err,a,"a","number")
	kbug(err,b,"b","number")
	local s=4*(math.sqrt(2)-1)/3
	local str=string.format("m %d %d b %d %d %d %d %d %d b %d %d %d %d %d %d b %d %d %d %d %d %d b %d %d %d %d %d %d ",a,0,a,-b*s,a*s,-b,0,-b,-a*s,-b,-a,-b*s,-a,0,-a,b*s,-a*s,b,0,b,a*s,b,a,b*s,a,0)
	return Kshape.move(str,x0,y0)
end

function shape.ellipse_ring(x0,y0,a1,b1,a2,b2)--椭圆环
	local str1=Kshape.ellipse(x0,y0,a1,b1)
	local str2=Kshape.ellipse(x0,y0,a2,b2)
	return str1..shape.reverse(str2)
end	

function shape.vari_color(ass_shape,color)
	local w,h=0,0
	local part={}
	for s in string.gmatch(ass_shape,"[m] [^m]+")
		do
		part[#part+1]=s
	end
	local new_shape=part[1]
	for i=2,#part
		do
		local x1,y1,x2,y2=_G.shape.bounding(part[i-1])
		local x3,y3,x4,y4=_G.shape.bounding(part[i])
		w,h=w+x2-x1,(i==2 and math.max(y4-y3,y2-y1) or math.max(h,y4-y3))
		part[i]=_G.shape.translate(part[i],-w,-h/2)
		new_shape=new_shape..string.format("{\\1c%s}",color[i-1])..part[i].." "
	end
	return new_shape
end

function qua_solution(a,b,c)--求解一元二次方程
	if (a==0)
		then
		if (b==0 and c==0)
			then return "const"
			elseif(b==0 and c~=0)
				then return "non"
			else return (c==0 and 0 or -c/b)
			end
		else
	local dis=b^2-4*a*c
	if dis==0
		then
		return -b/(2*a),-b/(2*a)
		elseif(dis>0)
			then
			return (math.sqrt(dis)-b)/(2*a),-(math.sqrt(dis)+b)/(2*a)
		else
			return "complex"
		end
	end
end

function three_order_func_count(tbl,t)--number，计算在t处的三次函数值
	local sum=0
	for i=0,3
		do
		sum=sum+tbl[i+1]*math.pow(t,3-i)
	end
	return sum
end

function three_order_func_minmax(tbl)--number,number，计算三次函数在0,1之间的最值
	local ep_s,ep_e=three_order_func_count(tbl,0),three_order_func_count(tbl,1)
	local der_c=der_poly(tbl,{3,2,1,0})
	table.remove(der_c)
	local a,b,c=der_c[1],der_c[2],der_c[3]
	local x1,x2=qua_solution(a,b,c)
	if (x1=="const")--情况1 ，原函数为常数
		then
		return ep_s,ep_s
		elseif (x1=="non")--情况2，导函数无零点
			then
			if (c>0)
				then
				return ep_s,ep_e
			else
				return ep_e,ep_s
			end
		elseif (x1=="complex")--情况3，导函数无实零点(原函数绝对单调)
			then
			if (a>0)
				then
				return ep_s,ep_e
			else
				return ep_e,ep_s
			end
			elseif (type(x1)=="number" and (not x2))--情况4，原函数三次项系数为0
				then
				local ep_in=three_order_func_count(tbl,x1)
				if (x1>=0 and x1<=1)
					then
					return math.min(ep_s,ep_e,ep_in),math.max(ep_s,ep_e,ep_in)
				else
					return math.min(ep_s,ep_e),math.max(ep_s,ep_e)
				end
				elseif (x1==x2)--情况5，原函数三次项系数不为0，导函数仅有一个零点
					then
					local ep_in=three_order_func_count(tbl,x1)
					if (x1>=0 and x1<=1)
						then
						return math.min(ep_s,ep_e,ep_in),math.max(ep_s,ep_e,ep_in)
					else
						return math.min(ep_s,ep_e),math.max(ep_s,ep_e)
					end
				else--情况6，原函数三次项系数不为0，导函数有两个零点
					local ep_in1,ep_in2=three_order_func_count(tbl,(x1>=0 and x1<=1 and x1 or 0)),three_order_func_count(tbl,(x2>=0 and x2<=1 and x2 or 0))
					return math.min(ep_s,ep_e,ep_in1,ep_in2),math.max(ep_s,ep_e,ep_in1,ep_in2)
				end
			end

function three_order_count(a,b,c,d,x)
	return ((a*x+b)*x+c)*x+d
end

function bezier_coe(x0,x1,x2,x3)
	local X3=3*x1+x3-3*x2-x0
	local X2=3*x0-6*x1+3*x2
	local X1=3*x1-3*x0
	local X0=x0
	return X3,X2,X1,X0
end

function cubic_solution(a,b,c,d,n0)
	local x0,f,f1
	local x=n0
	local k=0
	if math.abs(((a*n0+b)*n0+c)*n0+d)>0.0001
		then
		while(true)
			do
			k=k+1
			x0=x
			f=((a*x0+b)*x0+c)*x0+d
			f1=(3*a*x0+2*b)*x0+c
			x=x0-f/f1
			if (math.abs(x-x0)<0.0000000001 or k>190)
				then
				break
			end
		end
		return x
	else
		return n0
	end
end

function bezier_inter_tbl(vec,sx,sy,py)
	local tbl={}
	local x1,y1,x2,y2=_G.shape.bounding_real("m "..sx.." "..sy.." "..vec)
	local function delete_same(tbl)
		for i=1,#tbl-1
			do
			if tbl[i]
				then
				for p=i+1,#tbl
					do
					if tbl[i]==tbl[p]
						then
						tbl[p]=nil
					end
				end
			end
		end
		local new_tbl={}
		for i=1,#tbl
			do
			if tbl[i] and tbl[i]>=x1 and tbl[i]<=x2
				then
				new_tbl[#new_tbl+1]=tbl[i]
			end
		end
		return new_tbl
	end
	if (py>=y1 and py<=y2)
		then
		local pos=get_pos(vec)
		local ex,ey=pos.x[#pos.x],pos.y[#pos.y]
		table.insert(pos.x,1,sx)
		table.insert(pos.y,1,sy)
		local ex_t,ey_t=bezier_position(pos.x,pos.y,0.9)
		local sx_t,sy_t=bezier_position(pos.x,pos.y,0.1)
		local x0,x1,x2,x3=table.unpack(pos.x)
		local y0,y1,y2,y3=table.unpack(pos.y)
		local a,b,c,d=bezier_coe(y0,y1,y2,y3)
		local a1,b1,c1,d1=bezier_coe(x0,x1,x2,x3)
		local m=20
		for i=1,m
			do
			local x=cubic_solution(a,b,c,d-py,(i-1)/(m-1))
			if x
				then
				local y=three_order_count(a,b,c,d,x)
				local jx=three_order_count(a1,b1,c1,d1,x)
				local _,vx,vy=bezier_n_speed(pos.x,pos.y,x)
				local degree=comp_arg({vx,vy})
				if math.abs(y-py)<0.000001 and ((num(x,4)<1 and num(x,4)>0) or ((num(x,4)==1 and degree<=0) or (num(x,4)==0 and degree>=0)))
					then tbl[#tbl+1]=num(x,7)
				end
			end
		end
		return delete_same(tbl)
	else
		return {}
	end
end

sp=function(ass_shape,width)
	local pixels={}
	assert(type(ass_shape)=="string","ass_shape has to be a string value")
	local vec={}
	local x1,y1,x2,y2=shape.bounding_real(ass_shape)
	local function get_vec(ass_shape)
		local vec={}
		for s in string.gmatch(ass_shape,"[a-z][^a-z]+")
			do
			local pos=get_pos(s)
			vec[#vec+1]={str=s,sx,sy,ex=pos.x[#pos.x],ey=pos.y[#pos.y]}
		end
		for i=2,#vec+1
			do
			local ir=(i-1)%#vec+1
			local pos=get_pos(vec[i-1].str)
			vec[ir].sx,vec[ir].sy=pos.x[1],pos.y[1]
		end
		return vec
	end
	for s in string.gmatch(ass_shape,"[m][^m]+")
		do
		vec=table.add(vec,get_vec(s))
	end
	local function get_point(vector,sy)
		local pos={}
		local xpos={}
		for i=1,#vector
			do
			if string.match(vector[i].str,"b")
				then
				local pos1=bezier_inter_tbl(vector[i].str,vector[i].sx,vector[i].sy,sy)
				for i=1,#pos1
					do
					if pos1[i]>=x1 and pos1[i]<=x2
						then
						xpos[#xpos+1]=pos1[i]
					end
				end
			else
				if vector[i].ey~=vector[i].sy
					then
					local jy=num((vector[i].sy-sy)*(vector[i].ey-sy))
					if jy<0 or (jy==0 and sy==math.min(vector[i].sy,vector[i].ey))
						then
						local t=(sy-vector[i].sy)/(vector[i].ey-vector[i].sy)
						local t1=(sy-1-vector[i].sy)/(vector[i].ey-vector[i].sy)
						local ix=vector[i].sx*(1-t)+vector[i].ex*t
						local ix1=vector[i].sx*(1-t1)+vector[i].ex*t
						local a1,a2=math.ceil(ix)-ix,math.ceil(ix1)-ix1
						local b1,b2=ix-math.floor(ix),ix1-math.floor(ix1)
						local s1,s2=(a1+a2)/2,(b1+b2)/2
						xpos[#xpos+1]=ix
					end
				end
			end
		end
		table.sort(xpos,function(a,b) return a<b end)
		return xpos
	end
	for i=y1,y2,1
		do
		local pos0=table.copy_deep(get_point(vec,i))
		pixels[#pixels+1]=pos0
	end
	return pixels
end

function shape.bezier_to_line(ass_shape)
	if not string.match(ass_shape,"b")
		then
		return ass_shape
	else
		function op(x10,y10,x20,y20)
			return num(x10*y20-x20*y10,4)
		end
		local function get_vec(ass_shape)
			local vec={}
			for s in string.gmatch(ass_shape,"[a-z][^a-z]+")
				do
				vec[#vec+1]=s
			end
			for i=2,#vec+1
				do
				if string.match(vec[(i-1)%#vec+1],"b")
					then
					local ir=(i-1)%#vec+1
					local epos=get_pos(vec[ir])
					local spos=get_pos(vec[i-1])
					local x1,x2,x3=epos.x[1],epos.x[2],epos.x[3]
					local y1,y2,y3=epos.y[1],epos.y[2],epos.y[3]
					local x0,y0=spos.x[#spos.x],spos.y[#spos.y]
					if ((op(x1-x0,y1-y0,x2-x1,y2-y1)==0) and (op(x2-x1,y2-y1,x3-x2,y3-y2)==0))
						then
						vec[ir]="l "..x3.." "..y3.." "
					end
				end
			end
			return table.concat(vec)
		end
		local str=""
		for s in string.gmatch(ass_shape,"[m][^m]+")
			do
			str=str..get_vec(s)
		end
		return str
	end
end

function shape.simplify(ass_shape)--string，将绘图简化
	local err="wrong input to function:Kshape.simplify(ass_shape)\n"
	kbug(err,ass_shape,"ass_shape","string")
	ass_shape=_G.shape.bezier_to_line(ass_shape)
	local function op(x10,y10,x20,y20)
		return x10*y20-x20*y10
	end
	local function get_vec(ass_shape)
		local vec={}
		for s in string.gmatch(ass_shape,"[a-z][^a-z]+")
			do
			vec[#vec+1]={str=s,cut=true}
		end
		for i=3,#vec+2
			do
			local ir1=(i-2)%#vec+1
			local ir2=(i-1)%#vec+1
			if string.match(vec[ir1].str,"l") and string.match(vec[ir2].str,"l")
				then
				local pos1,pos2,pos3=get_pos(vec[i-2].str),get_pos(vec[ir1].str),get_pos(vec[ir2].str)
				local x0,y0,x1,y1,x2,y2=pos1.x[#pos1.x],pos1.y[#pos1.y],pos2.x[1],pos2.y[1],pos3.x[1],pos3.y[1]
				if num(op(x1-x0,y1-y0,x2-x1,y2-y1),4)==0
					then
					vec[ir1].cut=false
				end
			end
		end
		local str=""
		for i=1,#vec
			do
			if vec[i].cut
				then
				str=str..vec[i].str
			end
		end
		return string.gsub(str,"[a-z]","m",1)
	end
	local str=""
	for s in string.gmatch(ass_shape,"[m][^m]+")
		do
		str=str..get_vec(s)
	end
	return str
end

function cp(ass_shape,px,py)
	ass_shape=shape.simplify(ass_shape)
	local x1,y1,x2,y2=_G.shape.bounding_real(ass_shape)
	if (px>=x1 and px<=x2 and py>=y1 and py<=y2)
		then
		local function get_vec(ass_shape)
			local vec={}
			for s in string.gmatch(ass_shape,"[a-z][^a-z]+")
				do
				vec[#vec+1]={str=s,sx,sy}
			end
			for i=2,#vec+1
				do
				local ir=(i-1)%#vec+1
				local pos=get_pos(vec[i-1].str)
				local sx,sy=pos.x[#pos.x],pos.y[#pos.y]
				vec[ir].sx,vec[ir].sy=sx,sy
			end
			return vec
		end
		local function get_inter(vec,px,py)
			if string.match(vec.str,"b")
				then
				return bezier_inter(vec.str,vec.sx,vec.sy,px,py)
			else
				local pos=get_pos(vec.str)
				local x1,y1=pos.x[1],pos.y[1]
				local x0,y0=vec.sx,vec.sy
				if (not(y0==y1))
					then
					local jud=num((y0-py)*(y1-py))
					if jud<0
						then
						local t=num((py-y0)/(y1-y0),4)
						local ix=x0*(1-t)+x1*t
						if ix>=px
							then
							return 1
						else
							return 0
						end
					elseif jud==0
						then
						local ix=(y1>y0 and x0 or x1)
						if py==math.min(y1,y0) and ix>=px
							then
							return 1
						else
							return 0
						end
					else
						return 0
					end
				else
					return 0
				end
			end
		end
		k=0
		for s in string.gmatch(ass_shape,"[m][^m]+")
			do
			local vec=get_vec(s)
			for i=1,#vec
				do
				k=k+get_inter(vec[i],px,py)
			end
		end
		return (k%2==1)
	else
		return false
	end
end

function cp_test(ass_shape,px,py)
	ass_shape=shape.simplify(ass_shape)
	local function get_vec(ass_shape)
		local vec={}
		for s in string.gmatch(ass_shape,"[a-z][^a-z]+")
			do
			vec[#vec+1]={str=s,sx,sy}
		end
		for i=2,#vec+1
			do
			local ir=(i-1)%#vec+1
			local pos=get_pos(vec[i-1].str)
			local sx,sy=pos.x[#pos.x],pos.y[#pos.y]
			vec[ir].sx,vec[ir].sy=sx,sy
		end
		return vec
	end
	local function get_inter(vec,px,py)
		if string.match(vec.str,"b")
			then
			return bezier_inter(vec.str,vec.sx,vec.sy,px,py)
		else
			local pos=get_pos(vec.str)
			local x1,y1=pos.x[1],pos.y[1]
			local x0,y0=vec.sx,vec.sy
			if (not(y0==y1))
				then
				local jud=num((y0-py)*(y1-py))
				if jud<0
					then
					local t=num((py-y0)/(y1-y0),4)
					local ix=x0*(1-t)+x1*t
					if ix>=px
						then
						return 1
					else
						return 0
					end
				elseif jud==0
					then
					local ix=(y1>y0 and x0 or x1)
					if py==math.min(y1,y0) and ix>=px
						then
						return 1
					else
						return 0
					end
				else
					return 0
				end
			else
				return 0
			end
		end
	end
	k=0
	for s in string.gmatch(ass_shape,"[m][^m]+")
		do
		local vec=get_vec(s)
		for i=1,#vec
			do
			k=k+get_inter(vec[i],px,py)
		end
	end
	return (k%2==1)
end

function sp_test2(ass_shape)
	ass_shape=shape.close(shape.flat(ass_shape))
	local pos={}
	local vec_tbl={}
	local x1,y1,x2,y2=shape.bounding_real(ass_shape)
	for i=y1,y2
		do
		vec_tbl[i]={}
	end
	for s in ass_shape:gmatch("m[^m]+")
		do
		local sx,sy=s:match("([-%d.]+) ([-%d.]+)")
		local s_vec=s:match("[a-z][^a-z]+")
		sx,sy=tonumber(sx),tonumber(sy)
		while(true)
			do
			local x,y,v=s:match("([-%d.]+) ([-%d.]+) ([a-z][^a-z]+)")
			if x and y and s
				then
				x,y=tonumber(x),tonumber(y)
				ex,ey=v:match("([-%d.]+) ([-%d.]+)")
				ex,ey=tonumber(ex),tonumber(ey)
				s=s:gsub("[a-z][^a-z]+","",1)
				if ey~=y
					then
					for i=math.min(ey,y),math.max(ey,y)
						do
						vec_tbl[i][#vec_tbl[i]+1]={sx=x,sy=y,ex=ex,ey=ey}
					end
				end
			else
				break
			end
		end
	end
	for i=y1,y2
		do
		local xpos={}
		for p=1,#vec_tbl[i]
			do
			local sx,sy,ex,ey=vec_tbl[i][p].sx,vec_tbl[i][p].sy,vec_tbl[i][p].ex,vec_tbl[i][p].ey
			local it=num((i-sy)/(ey-sy),2)
			if ((it==0 or it==1) and i==math.min(sy,ey)) or (it>0 and it<1)
				then
				xpos[#xpos+1]=sx*(1-it)+ex*it
			end
		end
		table.sort(xpos,function(a,b) return a<b end)
		if #xpos>0
			then
			for p=1,#xpos,2
				do
				local len=math.ceil(xpos[p+1])-math.floor(xpos[p])-1
				local _,a1=math.modf(xpos[p])
				local _,a2=math.modf(xpos[p+1])
				for j=0,len
					do
					local a=(j==0 and 1-a1 or (j==len) and a2 or 1)
					pos[#pos+1]={x=(j==0 and xpos[p] or (j==len) and xpos[p+1]-1 or xpos[p]+(j)),y=i,alpha=255*a}
				end
			end
		end
	end
	return pos
end

function shape.get_vector_minmax(vector,s_x,s_y)--number,number,number,number，求曲线上坐标最值
	local pos=get_pos(vector)
	if #pos.x==1
		then
		return math.min(s_x,pos.x[1]),math.max(s_x,pos.x[1]),math.min(s_y,pos.y[1]),math.max(s_y,pos.y[1])
	else
		local c_x_tbl=bezier_coe_count({s_x,pos.x[1],pos.x[2],pos.x[3]})
		local c_y_tbl=bezier_coe_count({s_y,pos.y[1],pos.y[2],pos.y[3]})
		local min_x,max_x=three_order_func_minmax(c_x_tbl)
		local min_y,max_y=three_order_func_minmax(c_y_tbl)
		return min_x,max_x,min_y,max_y
	end
end

function shape.bounding_single(ass_shape_single)--number,number,number,number，包含单个图形最小矩形的坐标
	if type(_G.shape.get_command(ass_shape_single))~="string "
		then
		local vector=_G.shape.get_command(ass_shape_single)
		for i=2,#vector
			do
			local s_x,s_y=vector[i-1].x[#vector[i-1].x],vector[i-1].y[#vector[i-1].y]
			if i==2
				then
				min_x,max_x,min_y,max_y=_G.shape.get_vector_minmax(vector[i].str,s_x,s_y)
			else
				local x1,x2,y1,y2=_G.shape.get_vector_minmax(vector[i].str,s_x,s_y)
				min_x,max_x,min_y,max_y=math.min(x1,min_x),math.max(x2,max_x),math.min(y1,min_y),math.max(y2,max_y)
			end
		end
		return min_x,min_y,max_x,max_y
	else
		return 0,0,0,0
	end
end

function shape.bounding_real(ass_shape)--number,number,number,number，包含图形最小矩形的坐标
	local err="wrong input to function:Kshape.bounding_real(ass_shape)\n"
	kbug(err,ass_shape,"ass_shape","string")
	local single={}
	if string.match(ass_shape,"[m] [^m]+")
		then
		if string.match(ass_shape,"b")
			then
			for s in string.gmatch(ass_shape,"[m] [^m]+")
				do
				single[#single+1]=s
			end
			local min_x,min_y,max_x,max_y=_G.shape.bounding_single(single[1])
			for i=1,#single
				do
				local x1,y1,x2,y2=_G.shape.bounding_single(single[i])
				min_x,min_y,max_x,max_y=math.min(x1,min_x),math.min(y1,min_y),math.max(x2,max_x),math.max(y2,max_y)
			end
			return num(min_x,1),num(min_y,1),num(max_x,1),num(max_y,1)
		else
			local x0,y0=string.match(ass_shape,"([-%d.]+) ([-%d.]+)")
			x0,y0=tonumber(x0),tonumber(y0)
			local minx,maxx,miny,maxy=x0,x0,y0,y0
			for x,y in string.gmatch(ass_shape,"([-%d.]+) ([-%d.]+)")
				do
				x,y=tonumber(x),tonumber(y)
				minx,maxx,miny,maxy=math.min(minx,x),math.max(maxx,x),math.min(miny,y),math.max(maxy,y)
			end
			return minx,miny,maxx,maxy
		end
	else
		return 0,0,0,0
	end
end

function shape.bounding_an(ass_shape,mode)
	mode=(mode and mode or 5)
	mode=tonumber(mode)
	local x1,y1,x2,y2=_G.shape.bounding_real(ass_shape)
	local w,h=x2-x1,y2-y1
	local mx,my=(mode-1)%3,math.floor((mode-1)/3)
	return x1+mx*w/2,y2-my*h/2,Kshape.move(ass_shape,-x1-mx*w/2,-y2+my*h/2)
end

function shape.to_an(tbl,mode)
	local new_tbl={}
	for i=1,#tbl
		do
		new_tbl[i]=_G.shape.bounding_an(tbl[i].shape,mode)
	end
	return new_tbl
end
-----------高斯勒让德积分权重以及节点------------

gauss_x={-0.9931285991850940,
		-0.9639719272779130,
		-0.9122344282513260,
		-0.8391169718222180,
		-0.7463319064601500,
		-0.6360536807265150,
		-0.5108670019508270,
		-0.3737060887154190,
		-0.2277858511416450,
		-0.0765265211334973,
		0.0765265211334973,
		0.2277858511416450,
		0.3737060887154190,
		0.5108670019508270,
		0.6360536807265150,
		0.7463319064601500,
		0.8391169718222180,
		0.9122344282513260,
		0.9639719272779130,
		0.9931285991850940}

gauss_w={0.0176140071391521,
		0.0406014298003689,
		0.0626720483341090,
		0.0832767415767047,
		0.1019301198172400,
		0.1181945319615180,
		0.1316886384491760,
		0.1420961093183820,
		0.1491729864726030,
		0.1527533871307250,
		0.1527533871307250,
		0.1491729864726030,
		0.1420961093183820,
		0.1316886384491760,
		0.1181945319615180,
		0.1019301198172400,
		0.0832767415767047,
		0.0626720483341090,
		0.0406014298003689,
		0.0176140071391521}

function bezier_position(x_tbl,y_tbl,t)--n次贝赛尔曲线在t处的坐标值
	local function single_pos(tbl,t)
		local pos=0
		local n=#tbl-1
		for i=1,#tbl
			do
			pos=pos+tbl[i]*combin(n,i-1)*(t^(i-1))*((1-t)^(n-i+1))
		end
		return pos
	end
	return single_pos(x_tbl,t),single_pos(y_tbl,t)
end

function bezier_n_derivatives(tbl,t)
	local n=#tbl-1
	local der=0
	for i=1,n-1
		do
		der=der+combin(n,i)*tbl[i+1]*((1-t)^(n-i-1))*(t^(i-1))*(i-n*t)
	end
	der=der-tbl[1]*n*((1-t)^(n-1))+tbl[#tbl]*n*((t)^(n-1))
	return der
end

function bezier_n_speed(x_tbl,y_tbl,t)
	local dx,dy=bezier_n_derivatives(x_tbl,t),bezier_n_derivatives(y_tbl,t)
	return math.distance(dx,dy),dx,dy
end

function bezier_n_length(x_tbl,y_tbl,t)
	local len=0
	for i=1,#gauss_x
		do
		local ct=gauss_x[i]*t*0.5+t*0.5
		local v=bezier_n_speed(x_tbl,y_tbl,ct)
		len=len+gauss_w[i]*t*v/2
	end
	return len
end

function bezier_n_t_at_percent(x_tbl,y_tbl,pct)--三次贝塞尔曲线在百分之pct长度处的参数值
	local length=bezier_n_length(x_tbl,y_tbl,1)
	local s=length*pct/100
	local a=pct/100
	local k=0
	if a==0 or a==1
		then
		return a
	else
		while(true)
			do
			local v=bezier_n_speed(x_tbl,y_tbl,a)
			k=k+1
			b=a
			a=a-(bezier_n_length(x_tbl,y_tbl,a)-s)/v
			if (math.abs(a-b)<0.0001 or k>=500)--设定精度并防止死循环
				then
				break
			end
		end
		return a
	end
end

function bezier_n_uniform_speed(x_tbl,y_tbl,particle_width,a)
	local err="wrong input to function:Kbezier_uniform_speed(x_tbl,y_tbl,particle_width,accel)\n"
	a=(a and a or 1)
	kbug(err,x_tbl,"x_tbl","table")
	kbug(err,y_tbl,"y_tbl","table")
	kbug(err,particle_width,"particle_width","number")
	kbug(err,a,"accel",{"number","function"})
	if type(a)=="number"
		then
		assert(a>0,"accel has to be greater than 0")
	end
	local length=bezier_n_length(x_tbl,y_tbl,1)
	local max_n=math.ceil(length/particle_width)+1
	local pos={}
	for i=1,max_n
		do
		local t=(i-1)/(max_n-1)
		local t_f=(t-1)^2
		if type(a)=="function"
			then
			a1=a(t)
		else
			a1=a
		end
		local t_r=bezier_n_t_at_percent(x_tbl,y_tbl,100*(t^a1))
		local v,vx,vy=bezier_n_speed(x_tbl,y_tbl,t_r)
		local v1,vx1,vy1=bezier_n_speed(x_tbl,y_tbl,t)
		local degree=((vx==0 and vy==0) and 0 or math.deg(_G.comp_arg({vx,vy})))
		local degree1=((vx1==0 and vy1==0) and 0 or math.deg(_G.comp_arg({vx1,vy1})))
		pos[#pos+1]={}
		pos[#pos].x,pos[#pos].y=bezier_position(x_tbl,y_tbl,t_r)
		pos[#pos].x1,pos[#pos].y1=bezier_position(x_tbl,y_tbl,t)
		pos[#pos].deg=-degree
		pos[#pos].deg1=-degree1
	end
	return pos
end

function sin_position(x)
	if math.abs(x)<=math.pi
		then
		local out=0
		for i=1,20
			do
			out=out+math.pow(-1,i-1)*(x^(2*i-1))/permu(2*i-1,2*i-1)
		end
		return out
	elseif x<-math.pi
		then
		return sin_position(x+2*math.pi)
	elseif x>math.pi
		then
		return sin_position(x-2*math.pi)
	end
end

function sin_derivatives(x)
	if math.abs(x)<=math.pi
		then
		local out=0
		for i=1,5
			do
			out=out+math.pow(-1,i-1)*(2*i-1)*(x^(2*i-2))/permu(2*i-1,2*i-1)
		end
		return out
	elseif x<-math.pi
		then
		return sin_derivatives(x+2*math.pi)
	elseif x>math.pi
		then
		return sin_derivatives(x-2*math.pi)
	end
end

function sin_curve(A,f,p,v,t)
	local y=A*sin_position(f*2*math.pi*t+p)
	local x=v*t
	return x,y
end

function sin_speed(A,f,p,v,t)
	local vx=v
	local vy=A*2*math.pi*f*sin_derivatives(f*2*math.pi*t+p)
	return math.distance(vx,vy),vx,vy
end

function sin_length(A,f,p,v,t)
	local len=0
	for i=1,#gauss_x
		do
		local ct=gauss_x[i]*t*0.5+t*0.5
		local v=sin_speed(A,f,p,v,t)
		len=len+gauss_w[i]*t*v/2
	end
	return len
end

function sin_t_at_percent(A,f,p,v,pct)--三次贝塞尔曲线在百分之pct长度处的参数值
	local length=sin_length(A,f,p,v,1)
	local s=length*pct/100
	local a=pct/100
	local k=0
	if a==0 or a==1
		then
		return a
	else
		while(true)
			do
			k=k+1
			b=a
			a=a-(sin_length(A,f,p,v,a)-s)/sin_speed(A,f,p,v,a)
			if (math.abs(a-b)<0.00001 or k>=500)--设定精度并防止死循环
				then
				break
			end
		end
		return a
	end
end

function sin_uniform_speed(A,f,p,v,particle_width)
	local length=sin_length(A,f,p,v,1)
	local max_n=math.ceil(length/particle_width)
	local pos={}
	for i=1,max_n
		do
		local tr=sin_t_at_percent(A,f,p,v,100*(i-1)/(max_n-1))
		pos[#pos+1]={}
		pos[#pos].x,pos[#pos].y=sin_curve(A,f,p,v,tr)
	end
	return pos
end

function get_command_length(vector1,vector2)
	local len=0
	local pos1,pos2=get_pos(vector1),get_pos(vector2)
	local s_x,s_y=pos1.x[#pos1.x],pos1.y[#pos1.y]
	if #pos2.x==1
		then
		len=math.sqrt(math.pow(s_x-pos2.x[1],2)+math.pow(s_y-pos2.y[1],2))
	else
		local x0,y0=pos1.x[#pos1.x],pos1.y[#pos1.y]
		table.insert(pos2.x,1,x0)
		table.insert(pos2.y,1,y0)
		len=len+bezier_n_length(pos2.x,pos2.y,1)
	end
	return len
end

function shape.length_single(ass_shape)
	local vector={}
	for s in string.gmatch(ass_shape,"[a-z] [^a-z]+")
		do
		vector[#vector+1]=s
	end
	for i=1,#vector
		do
		length=(i==1 and 0 or length)+get_command_length(vector[i],vector[math.fmod(i,#vector)+1])
	end
	return length
end

function shape.len(ass_shape)
	local err="wrong input to function:Kshape.len(ass_shape)\n"
	kbug(err,ass_shape,"ass_shape","string")
	local sum=0
	for s in string.gmatch(ass_shape,"[m] [^m]+")
		do
		sum=sum+shape.length_single(s)
	end
	return sum
end

function get_command_point(vector1,vector2,t)
	local pos1,pos2=get_pos(vector1),get_pos(vector2)
	local s_x,s_y=pos1.x[#pos1.x],pos1.y[#pos1.y]
	if #pos2.x==1
		then
		local e_x,e_y=pos2.x[1],pos2.y[1]
		i_x,i_y=(e_x-s_x)*t+s_x,(e_y-s_y)*t+s_y
		local degree=math.deg(_G.comp_arg({e_x-s_x,e_y-s_y}))
		return num(i_x,1),num(i_y,1),degree
	else
		local c_x_tbl={s_x,pos2.x[1],pos2.x[2],pos2.x[3]}
		local c_y_tbl={s_y,pos2.y[1],pos2.y[2],pos2.y[3]}
		local tr=bezier_n_t_at_percent(c_x_tbl,c_y_tbl,t*100)
		local v,vx,vy=bezier_n_speed(c_x_tbl,c_y_tbl,tr)
		local degree=(vx==0 and vy==0 and 0 or math.deg(_G.comp_arg({vx,vy})))
		local i_x,i_y=bezier_position(c_x_tbl,c_y_tbl,tr)
		return num(i_x,1),num(i_y,1),degree
	end
end

function shape.get_point_single(ass_shape,particle_width,mode)
	local vec={}
	local p_pos={}
	local p_w=particle_width
	for s in string.gmatch(ass_shape,"[a-z] [^a-z]+")
		do
		vec[#vec+1]=s
	end
	if (mode=="close" or mode=="c")
		then
		mvec=#vec
	elseif (mode=="open" or mode=="o")
		then
		mvec=#vec-1
	elseif (not mode)
		then
		mvec=#vec
	else
		error("mode only supports \"close(c)\" or \"open(o)\"",2)
	end
	for i=1,mvec
		do
		local len=get_command_length(vec[i],vec[math.fmod(i,#vec)+1])
		local max_n=math.ceil(len/p_w)
		for p=1,max_n
			do
			p_pos[#p_pos+1]={x,y,deg}
			p_pos[#p_pos].x,p_pos[#p_pos].y,p_pos[#p_pos].deg=get_command_point(vec[i],vec[math.fmod(i,#vec)+1],p/max_n)
		end
	end
	return p_pos
end

function shape.get_point(ass_shape,particle_width,mode)
	local err="wrong input to function:Kshape.get_point(ass_shape,particle_width,mode)\n"
	kbug(err,ass_shape,"ass_shape","string")
	kbug(err,particle_width,"particle_width","number")
	mode=(mode and mode or "close")
	kbug(err,mode,"mode","string")
	assert(mode=="close" or mode=="c" or mode=="o" or mode=="open",err.."mode only supports \"close(c)\" or \"open(o)\"\nplease input correct mode")
	local part={}
	local pos={}
	for s in string.gmatch(ass_shape,"[m] [^m]+")
		do
		part[#part+1]=s
	end
	for i=1,#part
		do
		pos=table.add(pos,shape.get_point_single(part[i],particle_width,mode))
	end
	return pos
end

function points_inside_shape(ass_shape,max_points)--table，获取绘图内部点坐标
	local err="wrong input to function:Kshape.point_inside_shape(ass_shape,max_points)\n"
	kbug(err,ass_shape,"ass_shape","string")
	kbug(err,max_points,"max_points","number")
	local pos=table.mix(Yutils.shape.to_pixels(ass_shape))
	local outpos={}
	for i=1,math.min(#pos,max_points)
		do
		outpos[i]={x=pos[i].x,y=pos[i].y}
	end
	return outpos
end

function points_in_shape(ass_shape,max_points)--table，获取若干绘图命令点坐标
	local err="wrong input to function:Kshape.point_in_shape(ass_shape,max_points)\n"
	kbug(err,ass_shape,"ass_shape","string")
	kbug(err,max_points,"max_points","number")
	local vec={}
	for s in string.gmatch(ass_shape,"[a-z][^a-z]+")
		do
		vec[#vec+1]=s
	end
	vec=table.mix(vec)
	local outpos={}
	for i=1,math.min(max_points,#vec)
		do
		outpos[i]={x=get_pos(vec[i]).x[#get_pos(vec[i]).x],y=get_pos(vec[i]).y[#get_pos(vec[i]).y]}
	end
	return outpos
end

function route(ass_shape,particle_width)
	local pos={}
	local p_w=particle_width
	for s in string.gmatch(ass_shape,"[m][^m]+")
		do
		s=shape.close(s)
		local len=shape.length(s)
		local max_n=math.ceil(len/p_w)
		for i=1,max_n
			do
			local x,y=shape.point_at_percent(s,(i-1)/(max_n-1))
			pos[#pos+1]={x=x,y=y}
		end
	end
	return pos
end

function Kshape.point_at_percent(ass_shape,pct)
	ass_shape=shape.close(ass_shape)
	local t=pct/100
	local function pap_single(ass_shape)
		local vec={}
		for s in string.gmatch(ass_shape,"[a-z][^a-z]+")
			do
			vec[#vec+1]={str=s,sl,el}
		end
		local len=0
		for i=2,#vec+1
			do
			local ir=(i-1)%#vec+1
			local lent=get_command_length(vec[i-1].str,vec[ir].str)
			vec[ir].sl=len
			len=len+lent
			vec[ir].el=len
		end
		vec[1].sl,vec[1].el=0,0
		return vec
	end
	len_sum=shape.len(ass_shape)
	len_tl=len_sum*t
	local len_sl=0
	local len_el=0
	k=0
	local ix,iy=0,0
	for s in string.gmatch(ass_shape,"[m][^m]+")
		do
		k=k+1
		len_sl=(k==1 and len_sl or len_sl+shape.len(s))--起始总长度
		len_el=shape.len(s)+len_sl--终止总长度
		if len_tl>=len_sl and len_tl<=len_el
			then
			local st,et=len_sl/len_sum,len_el/len_sum
			local tl=len_tl-len_sl
			local vec=pap_single(s)
			for i=2,#vec+1
				do
				local ir=math.fmod(i-1,#vec)+1
				if tl>=vec[ir].sl and tl<=vec[ir].el and vec[ir].sl~=vec[ir].el
					then
					tr=(tl-vec[ir].sl)/(vec[ir].el-vec[ir].sl)
					ix,iy=get_command_point(vec[i-1].str,vec[ir].str,tr)
				end
			end
			break
		end
	end
	return {x=ix,y=iy}
end

function shape.intergration(ass_shape)--string，图形标准化
	local err="wrong input to function:Kshape.intergration(ass_shape)\n"
	kbug(err,ass_shape,"ass_shape","string")
	local str=ass_shape:gsub("c","")
	str=str:gsub("[a-z][^a-z]+",
		function(str)
			local new_str=""
			local pos=get_pos(str)
			if string.match(str,"b")
				then
				for i=1,#pos.x,3
					do
					new_str=new_str.."b "..num(pos.x[i]).." "..num(pos.y[i]).." "..num(pos.x[i+1]).." "..num(pos.y[i+1]).." "..num(pos.x[i+2]).." "..num(pos.y[i+2]).." "
				end
			else
				for i=1,#pos.x
					do
					new_str=new_str..string.match(str,"[a-z]").." "..num(pos.x[i]).." "..num(pos.y[i]).." "
				end
			end
			return new_str
		end
		)
	return shape.simplify(str)
end

function table.reverse(tbl)
	local new_tbl={}
	for i=1,#tbl
		do
		new_tbl[i]=table.copy_deep(tbl[#tbl-i+1])
	end
	return new_tbl
end

function shape.reverse_single(ass_shape)
	local pos=get_pos(ass_shape)
	local str="m "..pos.x[#pos.x].." "..pos.y[#pos.y].." "
	table.remove(pos.x,#pos.x)
	table.remove(pos.y,#pos.y)
	local k=0
	for s in string.gmatch(string.reverse(string.gsub(ass_shape,"m ","",1)),"[a-z]")
		do
		str=str..s.." "
		local k_temp=(s=="b" and 3 or 1)
		for i=1,k_temp
			do
			str=str..pos.x[#pos.x-k-i+1].." "..pos.y[#pos.x-k-i+1].." "
		end
		k=k+k_temp
	end
	return str
end

function shape.reverse(ass_shape,mode)
	local err="wrong input to function:Kshape.reverse(ass_shape,mode)\n"
	kbug(err,ass_shape,"ass_shape","string")
	mode=(mode and mode or "")
	kbug(err,mode,"mode","string")
	local function r_single(ass_shape)
		local pos=get_pos(ass_shape)
		local str="m "..pos.x[#pos.x].." "..pos.y[#pos.y].." "
		table.remove(pos.x,#pos.x)
		table.remove(pos.y,#pos.y)
		local k=0
		for s in string.gmatch(string.reverse(string.gsub(ass_shape,"m ","",1)),"[a-z]")
			do
			str=str..s.." "
			local k_temp=(s=="b" and 3 or 1)
			for i=1,k_temp
				do
				str=str..pos.x[#pos.x-k-i+1].." "..pos.y[#pos.x-k-i+1].." "
			end
			k=k+k_temp
		end
		return str
	end
	if mode~="part"
		then
		local str=""
		for s1 in string.gmatch(ass_shape,"[m][^m]+")
			do
			str=str..r_single(s1)
		end
		return str
	else
		return r_single(ass_shape)
	end
end

function vector_split(vector1,vector2,line_width)--将单个贝塞尔曲线绘图命令按长度(line_width)分割为直线段
	local l_w=line_width
	local vec2=vector2
	local pos1,pos2=get_pos(vector1),get_pos(vector2)
	local sx,sy=pos1.x[#pos1.x],pos1.y[#pos1.y]
	if #pos2.x==1
		then
		return vector2
	else
		local len=get_command_length(vector1,vector2)
		local max_p=math.ceil(len/l_w)
		for i=1,max_p
			do
			local i_x,i_y=get_command_point(vector1,vec2,i/max_p)
			vector2=(i==1 and "" or vector2).."l ".._G.num(i_x).." ".._G.num(i_y).." "
		end
		return vector2
	end
end

function shape.flat_single(ass_shape)
	local vec={}
	for s in string.gmatch(ass_shape,"[a-z] [^a-z]+")
		do
		vec[#vec+1]=s
	end
	for i=2,#vec
		do
		if string.match(vec[i],"b")
			then
			vec[i]=vector_split(vec[i-1],vec[i],1)
		end
	end
	return table.concat(vec)
end

function shape.flat(ass_shape)
	local err="wrong input to function:Kshape.flat(ass_shape)\n"
	kbug(err,ass_shape,"ass_shape","string")
	local part={}
	for s in string.gmatch(ass_shape,"[m] [^m]+")
		do
		part[#part+1]=shape.flat_single(s)
	end
	return table.concat(part)
end

function table.equal_test_delete(tbl)
	local new_tbl={}
	if #tbl==0
		then
		return tbl
	else
		table.sort(tbl)
		new_tbl[1]=tbl[1]
		for i=2,#tbl
			do
			if (tbl[i]~=tbl[i-1])
				then
				new_tbl[#new_tbl+1]=tbl[i]
			end
		end
		return new_tbl
	end
end

function get_intersection(vector,px,py)
	local function l_inter(x1,y1,x2,y2,py)
		local t=(py-y1)/(y2-y1)
		return x1+(x2-x1)*t
	end
	local pos=get_pos(vector.str)
	local ex,ey=pos.x[#pos.x],pos.y[#pos.y]
	local jud=(ey-py)*(vector.sy-py)
	if (jud<0 and ey~=vector.sy)
		then
		local ix=l_inter(vector.sx,vector.sy,ex,ey,py)
		if ix>px
			then
			return true
		else
			return false
		end
	elseif (jud==0 and ey~=vector.sy)
		then
		local ix=l_inter(vector.sx,vector.sy,ex,ey,py)
		if (py==math.max(ey,vector.sy) and ix>=px)
			then
			return true
		else
			return false
		end
	else
		return false
	end
end

function shape.delete_same_path(ass_shape)--删除图形内的无效路径(相同路径)
	local function get_vector(ass_shape)--获取直线命令并储存起始点和终点信息
		local vector={}
		for s in string.gmatch(ass_shape,"[a-z][^a-z]+")
			do
			local pos=get_pos(s)
			vector[#vector+1]={str=s,ex=pos.x[#pos.x],ey=pos.y[#pos.y],inter={},vec={}}
		end
		for i=2,#vector+1
			do
			local pos=get_pos(vector[i-1].str)
			vector[math.fmod(i-1,#vector)+1].sx,vector[math.fmod(i-1,#vector)+1].sy=pos.x[#pos.x],pos.y[#pos.y]
		end
		return vector
	end

	local vec=get_vector(ass_shape)
	for i=2,#vec-1
		do
		if vec[i].str
			then
			for p=i+1,#vec
				do
				if ((vec[i].ex~=vec[p].ex or vec[i].ey~=vec[p].ey))
					then
					break
				else
					vec[p]={str=nil}
				end
			end
		end
	end
	local str={}
	for i=1,#vec
		do
		if vec[i].str
			then
			str[#str+1]=vec[i].str
		end
	end
	return table.concat(str)
end

function shape.contains_point_test_single(ass_shape,px,py)
	local p_sum=0
	local vector={}
	ass_shape=(string.match(ass_shape,"b") and shape.flat(ass_shape) or ass_shape)
	for s in string.gmatch(ass_shape,"[a-z] [^a-z]+")
		do
		vector[#vector+1]={}
		vector[#vector].str=s
	end
	for i=2,#vector+1
		do
		local pos=get_pos(vector[i-1].str)
		vector[math.fmod(i-1,#vector)+1].sx,vector[math.fmod(i-1,#vector)+1].sy=pos.x[#pos.x],pos.y[#pos.y]
	end
	for i=1,#vector do
		if get_intersection(vector[i],px,py)
			then
			p_sum=p_sum+1
		end
	end
	return p_sum
end

function shape.inter_num(ass_shape,px,py)
	local p_sum=0
	for s in string.gmatch(ass_shape,"[m][^m]+")
		do
		p_sum=p_sum+shape.contains_point_test_single(s,px,py)
	end
	return p_sum
end

function shape.contains_point_test(ass_shape,px,py)
	local p_sum=0
	for s in string.gmatch(ass_shape,"[m][^m]+")
		do
		local sum=_G.shape.contains_point_test_single(s,px,py)
		if type(sum)=="number"
			then
		p_sum=p_sum+sum
	else
		break
		return true
	end
	end
	if p_sum%2==1
		then
		return true
	else
		return false
	end
end

function line_intersection_judge(x1,y1,x2,y2,x3,y3,x4,y4)
	local k1,b1=slope(x1,y1,x2,y2)
	local k2,b2=slope(x3,y3,x4,y4)
	local i_x,i_y=line_intersection(k1,b1,k2,b2)
	if i_x and i_y
		then
		if (i_x>=math.min(x1,x2) and i_x<=math.max(x1,x2) and i_y>=math.min(y1,y2) and i_y<=math.max(y1,y2)
			and i_x>=math.min(x3,x4) and i_x<=math.max(x3,x4) and i_y>=math.min(y3,y4) and i_y<=math.max(y3,y4))
			then
			return true
		else
			return false
		end
	else
		return false
	end
end

function shape.concavity(ass_shape)--table，判断任意多边形边的凹凸性
	local vec={}
	local num,jud=_G.shape.measure(ass_shape)
	for s in string.gmatch(ass_shape,"[a-z][^a-z]+")
		do
		vec[#vec+1]={str=s,con=true,mea=num}
	end
	for i=1,#vec
		do
		local pos=get_pos(vec[i].str)
		local spos=get_pos(vec[i==1 and #vec or i-1].str)
		local epos=get_pos(vec[math.fmod(i,#vec)+1].str)
		local x,y=pos.x[1],pos.y[1]
		local sx,sy=spos.x[1],spos.y[1]
		local ex,ey=epos.x[1],epos.y[1]
		local num1,jud1=_G.shape.measure(string.format("m %d %d l %d %d l %d %d ",sx,sy,x,y,ex,ey))
		if (jud1~=jud and num1~=0)
			then
			vec[i].con=false
			vec[i==1 and #vec or i-1].con=false
		end
	end
	return vec
end

function shape.tosame_single(ass_shape1,ass_shape2)
	ass_shape1,ass_shape2=shape.curvi(shape.simplify(ass_shape1)),shape.curvi(shape.simplify(ass_shape2))
	local str1,num1=string.gsub(ass_shape1,"[a-z]","")
	local str2,num2=string.gsub(ass_shape2,"[a-z]","")
	if num1>num2
		then
		local str=string.match(ass_shape2,"[a-z][^a-z]+$")
		local pos=get_pos(str)
		local x,y=pos.x[#pos.x],pos.y[#pos.y]
		for i=1,num1-num2
			do
			ass_shape2=ass_shape2.."b "..string.rep(tostring(x).." "..y.." ",3)
		end
	elseif num2>num1
		then
		local str=string.match(ass_shape1,"[a-z][^a-z]+$")
		local pos=get_pos(str)
		local x,y=pos.x[#pos.x],pos.y[#pos.y]
		for i=1,num2-num1
			do
			ass_shape1=ass_shape1.."b "..string.rep(tostring(x).." "..y.." ",3)
		end
	end
	return ass_shape1,ass_shape2
end

function shape.tosame(ass_shape1,ass_shape2)
	local function generate(x,y,ass_shape)
		ass_shape=shape.curvi(shape.simplify(ass_shape))
		local _,n=string.gsub(ass_shape,"[a-z]","")
		local str="m "..x.." "..y.." "
		return str..string.rep("b "..string.rep(tostring(x).." "..y.." ",3),n-1),ass_shape
	end
	local function part(ass_shape)
		local tbl={}
		for s in string.gmatch(ass_shape,"[m][^m]+")
			do
			tbl[#tbl+1]=s
		end
		return tbl
	end
	local part1,part2=part(ass_shape1),part(ass_shape2)
	local n1,n2=#part1,#part2
	if n1==n2
		then
		for i=1,n1
			do
			part1[i],part2[i]=shape.tosame_single(part1[i],part2[i])
		end
		return table.concat(part1),table.concat(part2)
	elseif n1>n2
		then
		local str=string.match(part2[#part2],"[a-z][^a-z]+$")
		local pos=get_pos(str)
		local x,y=pos.x[#pos.x],pos.y[#pos.y]
		for i=1,n2
			do
			part1[i],part2[i]=shape.tosame_single(part1[i],part2[i])
		end
		for i=1,n1-n2
			do
			part2[#part2+1],part1[i+n2]=generate(x,y,part1[i+n2])
		end
		return table.concat(part1),table.concat(part2)
	elseif n2>n1
		then
		local str=string.match(part1[#part1],"[a-z][^a-z]+$")
		local pos=get_pos(str)
		local x,y=pos.x[#pos.x],pos.y[#pos.y]
		for i=1,n1
			do
			part1[i],part2[i]=shape.tosame_single(part1[i],part2[i])
		end
		for i=1,n2-n1
			do
			part1[#part1+1],part2[i+n1]=generate(x,y,part2[i+n1])
		end
		return table.concat(part1),table.concat(part2)
	end
end

function to_same(ass_shape1,ass_shape2)
	local function part(ass_shape)
		local tbl={}
		for s in string.gmatch(ass_shape,"[m][^m]+")
			do
			tbl[#tbl+1]=s
		end
		return tbl
	end
	local part1,part2=part(ass_shape1),part(ass_shape2)
	for i=1,math.max(#part1,#part2)
		do
		local i1,i2=(i>#part1 and math.ceil(i/#part1)*#part1-i+1 or i),(i>#part2 and math.ceil(i/#part2)*#part2-i+1 or i)
		part1[i],part2[i]=shape.tosame_single(part1[i1],part2[i2])
	end
	return table.concat(part1),table.concat(part2)
end

function shape.transform(ass_shape1,ass_shape2,duration,ms)
	local err="wrong input to function:Kshape.transform(ass_shape1,ass_shape2,duration,ms)\n"
	kbug(err,ass_shape1,"ass_shape1","string")
	kbug(err,ass_shape2,"ass_shape2","string")
	kbug(err,duration,"duration","number")
	kbug(err,ms,"ms","number")
	local s1,s2=shape.tosame(ass_shape1,ass_shape2)
	local tbl={}
	local pos1,pos2=get_pos(s1),get_pos(s2)
	local function tr_single(s1,s2,t)
		local str=""
		local k=0
		for s in string.gmatch(s1,"[a-z]")
			do
			local k_temp=(s=="b" and 3 or 1)
			for i=1,k_temp
				do
				local tx=pos1.x[i+k]*(1-t)+pos2.x[i+k]*t
				local ty=pos1.y[i+k]*(1-t)+pos2.y[i+k]*t
				str=str..(i==1 and s.." " or "")..num(tx,1).." "..num(ty,1).." "
			end
			k=k+k_temp
		end
		return shape.simplify(str)
	end
	local max_n=math.ceil(duration/ms)
	for i=1,max_n
		do
		tbl[i]=tr_single(s1,s2,(i-1)/(max_n-1))
	end
	return tbl
end

function shape.to_outline_single(ass_shape,width)
	local x1,y1,x2,y2=shape.bounding_real(ass_shape)
	local x0,y0=(x1+x2)/2,(y1+y2)/2
	ass_shape=shape.translate(ass_shape,-x0,-y0)
	local sx,sy=string.match(ass_shape,"(-?[%d.]+) (-?[%d.]+)")
	local r=math.sqrt(math.pow(sx,2)+math.pow(sy,2))
	local scale=(r+width)/r
	return shape.translate(ass_shape..Yutils.shape.filter(shape.reverse(ass_shape),function(x,y) return x*scale,y*scale end),x0,y0)
end

function shape.to_outline(ass_shape,width)
	local str={}
	for s in string.gmatch(ass_shape,"[m][^m]+")
		do
		str[#str+1]=shape.to_outline_single(s,width)
	end
	return table.concat(str," ")
end

function shape.p_outline(ass_shape,width,pattern_len,space_len,dash_offset)
	local str=shape.pattern_outline(ass_shape,width,"round","round",pattern_len,space_len,dash_offset)
	local pos={}
	for s in str:gmatch("m[^m]+")
		do
		local x1,y1,x2,y2=shape.bounding_coords(s)
		local x0,y0=(x1+x2)/2,(y1+y2)/2
		pos[#pos+1]={shape=shape.translate(s,-x0,-y0),x=x0,y=y0}
	end
	return pos
end

function lightning_pos(x1,y1,x2,y2,displace,tbl)
	tbl[#tbl+1]={x1,y2,x2,y2}
	return tbl
end

function drawLightning_pos(x1,y1,x2,y2,displace,curDetail)
	local pos={}
	repeat
		pos[#pos+1]={x1,y1,x2,y2}
		local mid_x=(x2+x1)/2
    	local mid_y=(y2+y1)/2
    	mid_x=mid_x+(math.random()-0.5)*displace
   		mid_y=mid_y+(math.random()-0.5)*displace
   		displace=displace/2
    	lightning_pos(x1,y1,mid_x,mid_y,displace/2,pos)
    	lightning_pos(x2,y2,mid_x,mid_y,displace/2,pos)
    	until displace<=curDetail
    return pos
end

function drawLightning(x1,y1,x2,y2,displace,curDetail)
	local pos=drawLightning_pos(x1,y1,x2,y2,displace,curDetail)
	local str=""
	local vec={}
	for i=1,#pos
		do
		str=str..(i==1 and "m " or "l ")..num(pos[i][1]).." "..num(pos[i][2]).." "..num(pos[i][3]).." "..num(pos[i][4]).." "
	end
	local t_str=string.gsub(shape.reverse(str),"m","l")
	return str..t_str
end

function text_to_fragment(text_shape,tbl)--table，将文字按图形集合碎片化
	local frag={}
	for i=1,#tbl
		do
		if type(tbl[i])~="string"
			then error("frag_shape must be a string value\n")
		else
			local frag_shape=_G.shape.intersected(text_shape,tbl[i])
			local _,n=string.gsub(frag_shape,"[a-z]","")
			if (n>1)
				then
				frag[#frag+1]={}
				local x1,y1,x2,y2=_G.shape.bounding_real(frag_shape)
				frag[#frag].x,frag[#frag].y=(x1+x2)/2,(y1+y2)/2
				frag[#frag].shape=_G.shape.translate(frag_shape,-(x1+x2)/2,-(y1+y2)/2)
			end
		end
	end
	return frag
end

function line_generate(x,y,pw,mode)
	mode=(mode and mode or "")
	local err="wrong input to function:line_generate(x,y,particle_width,mode)\n"
	kbug(err,x,"x","table")
	kbug(err,y,"y","table")
	kbug(err,pw,"particle_width","number")
	kbug(err,mode,"mode","string")
	assert(mode=="x" or mode=="y" or mode=="rand" or mode=="",err.."mode only supports \"x\",\"y\",\"rand\" please input a correct mode")
	local new_x,new_y={},{}
	local tbl={}
	local pos={}
	if mode=="x" or mode=="y"
		then
		new_x[1],new_y[1]=x[1],y[1]
		for i=2,2*#x-1
			do
			new_x[i]=(((mode=="x" and i%2==0) or (mode=="y" and i%2==1)) and new_x[i-1] or x[math.floor(i/2)+1])
			new_y[i]=(((mode=="x" and i%2==0) or (mode=="y" and i%2==1)) and y[math.floor(i/2)+1] or new_y[i-1])
			local len0=math.ceil(math.distance(new_x[i]-new_x[i-1],new_y[i]-new_y[i-1]))
			tbl[#tbl+1]=len0
		end
	elseif mode=="rand"
		then
		local m={"x","y"}
		new_x[1]=x[1]
		new_y[1]=y[1]
		for i=2,#x
			do
			local mode1=m[math.random(1,2)]
			if mode1=="x"
				then
				new_x[#new_x+1]=new_x[2*i-3]
				new_y[#new_y+1]=y[i]
			else
				new_x[#new_x+1]=x[i]
				new_y[#new_y+1]=new_y[2*i-3]
			end
			new_x[#new_x+1]=x[i]
			new_y[#new_y+1]=y[i]
		end
		for i=1,#new_x-1
			do
			tbl[#tbl+1]=math.ceil(math.distance(new_x[i+1]-new_x[i],new_y[i+1]-new_y[i]))
		end
	else
		new_x,new_y=x,y
		for i=1,#x-1
			do
			local len0=math.ceil(math.distance(x[i+1]-x[i],y[i+1]-y[i]))
			tbl[#tbl+1]=len0
		end
	end
	local l,max=loop_n2(tbl)
	for i=1,max
		do
		local j1,max1=l[i].j1,l[i].max1
		local j2=l[i].j2
		local ix=new_x[j2]*(1-j1/max1)+new_x[j2+1]*(j1/max1)
		local iy=new_y[j2]*(1-j1/max1)+new_y[j2+1]*(j1/max1)
		pos[#pos+1]={x=num(ix,1),y=num(iy,1)}
	end
	return pos
end

table.most=function(tbl)
	assert(type(tbl)=="table","input is not a table value")
	assert(#tbl>0,"the length of input has to be greater than 0")
	local maxt,mint
	for i=1,#tbl
		do
		maxt=(i==1 and tbl[1] or math.max(maxt,tbl[i]))
		mint=(i==1 and tbl[1] or math.min(mint,tbl[i]))
	end
	return maxt,mint
end

math.range=function(interpolate,min,max)
	min1,max1=math.min(min,max),math.max(min,max)
	if interpolate<min1
		then
		return min1
	elseif interpolate>max1
		then
		return max1
	else
		return interpolate
	end 
end

linegrid=function(min,max,pw)
	local x={}
	local mx=math.ceil((max-min)/pw)
	for i=0,mx
		do
		x[#x+1]=min*(1-i/mx)+max*i/max
	end
	return x
end

meshgrid=function(min1,max1,min2,max2,pw1,pw2)
	local x,y={},{}
	pw1,pw2=(pw1 and pw1 or 1),(pw2 and pw2 or 1)
	local mx,my=math.ceil((max1-min1)/pw1),math.ceil((max2-min2)/pw2)
	for i=0,mx
		do
		for p=0,my
			do
			x[#x+1]=min1*(1-i/mx)+max1*(i/mx)
			y[#y+1]=min2*(1-p/my)+max2*(p/my)
		end
	end
	return x,y
end

ringgrid=function(r1,r2,rad1,rad2,pr,pt)
	local x,y={},{}
	pr=(pr and pr or 1)
	pt=(pt and pt or 1)
	local mr,mt=math.ceil((r2-r1)/pr),math.ceil((rad2-rad1)/pt)
	for i=0,mr
		do
		for p=0,mt
			do
			local r,t=r1*(1-i/mr)+r2*i/mr,rad1*(1-p/mt)+rad2*p/mt
			x[#x+1]=num(r*math.cos(t),3)
			y[#y+1]=num(r*math.sin(t),3)
		end
	end
	return x,y
end

function mandelbrot_set(pr,pt)
	local pos={}
	local x,y=ringgrid(0,2,0,math.pi*2,pr,pt)
	for i=1,#x
		do
		local z0={0,0}
		k=0
		repeat
			k=k+1
			z0=_G.comp_add(_G.comp_pow(z0,2),{x[i],y[i]})
		until (k>20 or comp_length(z0)>2 or (not _G.comp_pow(z0,2)))
		if k>=10
			then
			pos[#pos+1]={x=x[i],y=y[i],H=k/21}
		end
	end
	return pos
end

function julia_set(pr,pt,c)
	local pos={}
	local x,y=ringgrid(0,2,0,math.pi*2,pr,pt)
	for i=1,#x
		do
		local z0={x[i],y[i]}
		k=0
		repeat
			k=k+1
			z0=_G.comp_add(_G.comp_pow(z0,2),c)
		until (k>20 or comp_length(z0)>2 or (not _G.comp_pow(z0,2)))
		if k>=10
			then
			pos[#pos+1]={x=x[i],y=y[i],H=k/21}
		end
	end
	return pos
end

function P(x,y,max_n)
	local k=0
	for i=1,max_n
		do
		local x1,y1=math.random(-x,x)+math.random(),math.random(-y,y)+math.random()
			if math.pow(x1,2)+math.pow(y1,2)<=y^2
				then
				k=k+1
			end
		end
		return 4*k/max_n
	end

--以下为复平面内运算定义(复数以table形式输入，complex={Re,Im})

function comp_to_comp(tbl)
	local new_tbl
	if type(tbl)=="number"
		then
		new_tbl={tbl,0}
	elseif type(tbl)=="table"
		then
		new_tbl=tbl
	else
		error("wrong input to complex!!")
	end
	kbug("wrong input to complex!!\n",new_tbl[1],"Re","number")
	kbug("wrong input to complex!!\n",new_tbl[2],"Im","number")
	return new_tbl
end

function comp_conju(tbl)--table，复数共轭计算
	tbl=comp_to_comp(tbl)
	return {tbl[1],-tbl[2]}
end

function comp_length(tbl)--number，复数模计算
	tbl=comp_to_comp(tbl)
	return math.sqrt(math.pow(tbl[1],2)+math.pow(tbl[2],2))
end

function comp_arg(tbl)--number，复数主幅角
	tbl=comp_to_comp(tbl)
	if tbl[1]>0--一，四象限，x轴正半轴
		then
		return math.atan(tbl[2]/tbl[1]) 
	elseif (tbl[1]<0 and tbl[2]~=0)--二三象限
		then
		return math.pi*math.abs(tbl[2])/tbl[2]+math.atan(tbl[2]/tbl[1])
	elseif (tbl[1]<0 and tbl[2]==0)--x轴负半轴
		then 
		return math.pi
	elseif (tbl[1]==0 and tbl[2]~=0)--y轴（不含原点）
		then
		return math.pi*(math.abs(tbl[2])/tbl[2])/2
	elseif (tbl[1]==0 and tbl[2]==0)--原点
		then
		return 0
	end
end

function comp_add(tbl_1,tbl_2)--table，复数加法
	tbl_1=comp_to_comp(tbl_1)
	tbl_2=comp_to_comp(tbl_2)
	return {tbl_1[1]+tbl_2[1],tbl_1[2]+tbl_2[2]}
end

function comp_sub(tbl_1,tbl_2)--复数减法
	tbl_1=comp_to_comp(tbl_1)
	tbl_2=comp_to_comp(tbl_2)
	return {tbl_1[1]-tbl_2[1],tbl_1[2]-tbl_2[2]}
end

function comp_multi(tbl_1,tbl_2)--复数乘法
	tbl_1=comp_to_comp(tbl_1)
	tbl_2=comp_to_comp(tbl_2)
	return {tbl_1[1]*tbl_2[1]-tbl_1[2]*tbl_2[2],tbl_1[1]*tbl_2[2]+tbl_1[2]*tbl_2[1]}
end

function comp_div(tbl_1,tbl_2)--复数除法
	tbl_1=comp_to_comp(tbl_1)
	tbl_2=comp_to_comp(tbl_2)
	if tbl_2[1]==0 and tbl_2[2]==0
		then
		_G.aegisub.debug.out("the length of z2 can't be 0\n")
	else
		local len_z2=comp_length(tbl_2)^2
		return {(tbl_1[1]*tbl_2[1]+tbl_1[2]*tbl_2[2])/len_z2,(tbl_1[2]*tbl_2[1]-tbl_1[1]*tbl_2[2])/len_z2}
	end
end

function comp_exp(tbl)--复指数
	tbl=comp_to_comp(tbl)
	local len=math.exp(tbl[1])
	return {len*math.cos(tbl[2]),len*math.sin(tbl[2])}
end

function comp_sin(tbl)--正弦函数
	tbl=comp_to_comp(tbl)
	local z1,z2=comp_multi(tbl,{0,1}),comp_multi(tbl,{0,-1})
	return comp_div(comp_sub(comp_exp(z1),comp_exp(z2)),{0,2})
end

function comp_cos(tbl)--余弦函数
	tbl=comp_to_comp(tbl)
	local z1,z2=comp_multi(tbl,{0,1}),comp_multi(tbl,{0,-1})
	return comp_div(comp_add(comp_exp(z1),comp_exp(z2)),{2,0})
end

function comp_tan(tbl)--正切函数
	tbl=comp_to_comp(tbl)
	return comp_div(comp_sin(tbl),comp_cos(tbl))
end

function comp_cot(tbl)--余切函数
	tbl=comp_to_comp(tbl)
	return comp_div({1,0},comp_tan(tbl))
end

function comp_xy_to_polar(tbl)--直角坐标式转极坐标式
	tbl=comp_to_comp(tbl)
	local len=comp_length(tbl)
	local arg1=comp_arg(tbl)
	return {len,arg1}
end

function comp_polar_to_xy(tbl)--极坐标式转直角坐标式
	tbl=comp_to_comp(tbl)
	return {tbl[1]*math.cos(tbl[2]),tbl[1]*math.sin(tbl[2])}
end

function comp_pow(tbl,z_n)--复数幂函数
	tbl=comp_to_comp(tbl)
	local tbl_e=comp_xy_to_polar(tbl)
	if type(z_n)=="number"
		then
		return comp_polar_to_xy({math.pow(tbl_e[1],z_n),tbl_e[2]*z_n})
	else
		local r=math.pow(tbl_e[1],z_n[1])*math.exp(-z_n[2]*tbl_e[2])
		local arg=tbl_e[2]*z_n[1]+z_n[2]*math.log(tbl_e[1])
		return comp_polar_to_xy({r,arg})
	end
end

----傅里叶演示动画-----

function Fourier_coefficient(m,n,a,b)
	if n==0
		then
		local out1=comp_polar_to_xy({1,-m*b})
		local out2=comp_polar_to_xy({1,-m*a})
		local out=comp_sub(out1,out2)
		out=comp_multi({0,1/(2*math.pi*m)},out)
		return out
	else
		local c1={0,-n/((b-a)*m)}
		local c2=comp_polar_to_xy({1/(2*math.pi*m),-m*b})
		return comp_sub(c2,comp_multi(c1,Fourier_coefficient(m,n-1,a,b)))
	end
end

function CTFT(func,jw,dt)
	local sum={0,0}
	local max_n=math.ceil(2000/dt)
	for i=0,max_n
		do
		xt={func(-1000+dt*(i-1)),0}
		ejwt=comp_polar_to_xy({1,-jw*(-1000+(i-1)*dt)})
		xt=comp_multi(xt,ejwt)
		sum=comp_add(sum,xt)
	end
return sum
end

function FFT(sample,k)--傅里叶变换
	local w={0,0}
	local M=math.ceil(math.log(#sample,2))
	local N=math.pow(2,M)
	for i=1,N/2
		do
		local ir=tonumber(string.reverse(tobinary(i-1,M-1)),2)
		local x0,xh={sample[ir+1] and sample[ir+1] or 0,-ir*math.pi*k*2/N},{sample[ir+N/2+1] and sample[ir+N/2+1] or 0,-(ir+N/2)*k*math.pi*2/N}
		x0,xh=comp_polar_to_xy(x0),comp_polar_to_xy(xh)
		w=comp_add(w,comp_add(xh,x0))
	end
	return w
end

function multiloop(multi,j,maxj)
	j_fx1=math.fmod(j-1,maxj/multi)+1
	maxj_fx1=maxj/multi
	j_fx2=math.floor((j-1)/(maxj/multi))+1
	maxj_fx2=multi
	return""
end

function table.filter(tbl,filter)
	for i=1,#tbl-1
		do
		for p=i+1,#tbl
			do
			if filter(tbl[i],tbl[p])
				then
				tbl[i],tbl[p]=tbl[p],tbl[i]
			end
		end
	end
	return
	tbl
end

------------------矩阵运算---------------------
function matrix_check(mat)
	local m=#mat
	if (m<1)
		then
		error("矩阵为空！")
	else
		for i=2,m
			do
			local n1,n2=#mat[i-1],#mat[i]
			if (n1<1 or n2<1)
				then
				error("矩阵含空列！")
				elseif (n1~=n2)
					then
					error("矩阵列内元素数量不一致！")
				end
			end
		end
	end

function matrix_rand(m,n,min,max)
	local tbl={}
	for i=1,m
		do
		tbl[#tbl+1]={}
		for p=1,n
			do
			tbl[i][p]=math.random(min,max)
		end
	end
	return tbl
end

function matrix_add(mat1,mat2)
	local err="wrong input to function:Kmatrix.add(mat1,mat2)\n"
	kbug(err,mat1,"mat1","table")
	kbug(err,mat2,"mat2","table")
	matrix_check(mat1)
	matrix_check(mat2)
	local mat={}
	local m1,n1=#mat1,#mat1[1]
	local m2,n2=#mat2,#mat2[1]
	if (m1==m2 and n1==n2)
		then
		for i=1,m1
			do
			mat[i]={}
			for p=1,n1
				do
				mat[i][p]=mat1[i][p]+mat2[i][p]
			end
		end
	else
		error("矩阵维度不一致！")
	end
	return mat
end

function matrix_sub(mat1,mat2)
	local err="wrong input to function:Kmatrix.sub(mat1,mat2)\n"
	kbug(err,mat1,"mat1","table")
	kbug(err,mat2,"mat2","table")
	matrix_check(mat1)
	matrix_check(mat2)
	local m1,n1=#mat1,#mat1[1]
	local m2,n2=#mat2,#mat2[1]
	local mat={}
	if (m1==m2 and n1==n2)
		then
		for i=1,m1
			do
			mat[i]={}
			for p=1,n1
				do
				mat[i][p]=mat1[i][p]-mat2[i][p]
			end
		end
	else
		error("矩阵维度不一致！")
	end
	return mat
end

function matrix_transposition(mat)
	local err="wrong input to function:Kmatrix.transposition(mat)\n"
	kbug(err,mat,"mat","table")
	matrix_check(mat)
	local new_mat={}
	local m,n=#mat,#mat[1]
	for i=1,n
		do
		new_mat[i]={}
		for p=1,m
			do
			new_mat[i][p]=mat[p][i]
		end
	end
	return new_mat
end

function matrix_multi_number(mat,number)
	local err="wrong input to function:Kmatrix.multi_number(mat,num)\n"
	kbug(err,mat,"mat","table")
	kbug(err,number,"num","number")
	matrix_check(mat)
	local new_mat={}
	local m,n=#mat,#mat[1]
	for i=1,m
		do
		new_mat[i]={}
		for p=1,n
			do
			new_mat[i][p]=number*mat[i][p]
		end
	end
	return new_mat
end

function matrix_multi_matrix(mat1,mat2)
	local err="wrong input to function:Kmatrix.multi_matrix(mat1,mat2)\n"
	kbug(err,mat1,"mat1","table")
	kbug(err,mat2,"mat2","table")
	matrix_check(mat1)
	matrix_check(mat2)
	local new_mat={}
	local m1,n1,m2,n2=#mat1,#mat1[1],#mat2,#mat2[1]
	if (m2~=n1)
		then
		error("矩阵行列数不对应，无法相乘！")
	else
		for i=1,m1
			do
			new_mat[i]={}
			for p=1,n2
				do
				new_mat[i][p]=0
				for q=1,n1
					do
				new_mat[i][p]=num(new_mat[i][p]+mat1[i][q]*mat2[q][p],2)
			end
		end
	end
end
return new_mat
end

function deter_delete(tbl,i,j)--table，行列式删除某行某列(行列式计算辅助函数)
	local new_tbl={}
	for i=1,#tbl
		do
		new_tbl[i]={}
		for p=1,#tbl[i]
			do
			new_tbl[i][p]=tbl[i][p]
		end
	end
	for i=1,#new_tbl
		do
		_G.table.remove(new_tbl[i],j)
	end
	_G.table.remove(new_tbl,i)
	return new_tbl
end

function deter_value(tbl)--number，行列式值计算
	local err="wrong input to function:Kmatrix.value(mat)\n"
	kbug(err,tbl,"mat","table")
	local sum=0
	if #tbl==2
		then
		return tbl[1][1]*tbl[2][2]-tbl[1][2]*tbl[2][1]
	elseif #tbl==1
		then
		return tbl[1][1]
	else
		for i=1,#tbl[1]
			do
			sum=sum+tbl[1][i]*math.pow(-1,i-1)*deter_value(deter_delete(tbl,1,i))
		end
		return sum
	end
end

function matrix_adjoint(mat)--table，计算伴随矩阵
	local err="wrong input to function:Kmatrix.adjoint(mat)\n"
	kbug(err,mat,"mat","table")
	matrix_check(mat)
	local new_mat={}
	for i=1,#mat
		do
		new_mat[i]={}
		for p=1,#mat[i]
			do
			new_mat[i][p]=math.pow(-1,p-1)*math.pow(-1,i-1)*deter_value(deter_delete(mat,i,p))
		end
	end
	return matrix_transposition(new_mat)
end

function matrix_inverse(mat)--table，计算逆矩阵
	local err="wrong input to function:Kmatrix.inverse(mat)\n"
	kbug(err,mat,"mat","table")
	matrix_check(mat)
	local len=deter_value(mat)
	if len==0
		then
		error("the inverse matrix dose not exist",2)
	else 
		return matrix_multi_number(matrix_adjoint(mat),1/len)
	end
end

----------------------极限以及导数，定积分积分运算----------------------

function limited(func,x,dx)--number，求函数在某点的极限值
	if func(x)
		then 
		return func(x)
	else
	return func(x-dx)/2+func(x+dx)/2
end
end

function derivative(func,x)--number，求函数在某点的导数近似值
	return (func(x+0.0000001)-func(x))/(0.0000001)
end

function integral_1_dx(func,a,b,dx)--number，求y=f(x)或x=g(y)一型线积分
	local sum=0
	local len=math.abs(b-a)
	if len~=0
		then
	local max_n=math.ceil(len/dx)
	for i=1,max_n+1
		do
		local der_func=derivative(func,math.min(a,b)+(i-1)*dx)
		sum=sum+math.sqrt(1+der_func^2)*dx
	end
	return sum*(b-a)/len
else
	return 0
end
end

function integral_1_dt(func_x,func_y,t1,t2,dt)--number，求y=f(t),x=g(t)一型线积分
	local sum=0
	local len=math.abs(t2-t1)
	if len~=0
		then
	local max_n=math.ceil(len/dt)
		for i=0,max_n
			do
			local der_x=derivative(func_x,math.min(t1,t2)+i*dt)
			local der_y=derivative(func_y,math.min(t1,t2)+i*dt)
			sum=sum+dt*math.sqrt(math.pow(der_x,2)+math.pow(der_y,2))
		end
		return sum*len/(t2-t1)
	else
		return 0
	end
end

function get_RGB(color)--number,number,number，获取ass颜色代码RGB参数
	local err="wrong input to function:Kcolor.get_RGB(color)\n"
	kbug(err,color,"color","string")
	color=string.gsub(string.gsub(color,"&",""),"H","")
	local b,g,r=string.sub(color,1,2),string.sub(color,3,4),string.sub(color,5,6)
	b,g,r=_G.tonumber(b,16),_G.tonumber(g,16),_G.tonumber(r,16)
	return r,g,b
end

function RGB_to_HSV(r,g,b)--number,number,number，RGB参数转化为HSV参数
	local err="wrong input to function:Kcolor.RGB_to_HSV(r,g,b)\n"
	kbug(err,r,"r","number")
	kbug(err,g,"g","number")
	kbug(err,b,"b","number")
	local H,S,V
	local R,G,B=r/255,g/255,b/255
	local C_max,C_min=math.max(R,G,B),math.min(R,G,B)
	local Dc=C_max-C_min
	V=C_max
	S=(C_max==0 and 0 or Dc/C_max)
	if (Dc==0)
		then
			H=0
	elseif (C_max==R)
		then
			H=(G>=B and 60*(G-B)/Dc or 60*(G-B)/Dc+360)
	elseif (C_max==G)
		then
			H=60*(B-R)/Dc+120
	elseif (C_max==B)
		then
			H=60*(R-G)+240
	end
	return H,S,V
end

function RGB_to_HSL(r,g,b)--number,number,number，RGB参数转化为HSL参数
	local err="wrong input to function:Kcolor.RGB_to_HSL(r,g,b)\n"
	kbug(err,r,"r","number")
	kbug(err,g,"g","number")
	kbug(err,b,"b","number")
	local H,S,L
	local R,G,B=r/255,g/255,b/255
	local C_max,C_min=math.max(R,G,B),math.min(R,G,B)
	local Dc=C_max-C_min
	L=(C_max+C_min)/2
	if (L==0 or C_min==C_max)
		then
		S=0
		elseif (L>0 and L<=0.5)
			then
			S=(C_max-C_min)/(2*L)
		else
			S=(C_max-C_min)/(2-2*L)
	end
	if (Dc==0)
		then
			H=0
	elseif (C_max==R)
		then
			H=(G>=B and 60*(G-B)/Dc or 60*(G-B)/Dc+360)
	elseif (C_max==G)
		then
			H=60*(B-R)/Dc+120
	elseif (C_max==B)
		then
			H=60*(R-G)+240
	end
	return H,S,L
end

function HSL_to_RGB1(h,s,l)
	local err="wrong input to function:Kcolor.HSL_to_RGB(h,s,l)\n"
	kbug(err,h,"h","number")
	kbug(err,s,"s","number")
	kbug(err,l,"l","number")
	local function para_range(t)
		if t<0
			then
			return t+1
		elseif t>1
			then
			return t-1
		else
			return t
		end
	end
	local q
	if l>=0.5
		then
		q=l+s-(l*s)
	else
		q=l*(1+s)
	end
	local p=2*l-q

	local function get_para(t)
		t=para_range(t)
		if t<1/6
			then
			return p+((q-p)*6*t)
		elseif t<1/2 and t>=1/6
			then
			return q
		elseif t>=1/2 and t<2/3
			then
			return p+((q-p)*6*(2/3-t))
		else
			return p
		end
	end

	if s==0
		then
		return num(l*255),num(l*255),num(l*255)
	else
		local hk=h/360
		local r=get_para(hk+1/3)
		local g=get_para(hk)
		local b=get_para(hk-1/3)
		return num(r*255),num(g*255),num(b*255)
	end
end

function HSV_to_RGB1(h,s,v)
	local err="wrong input to function:Kcolor.HSV_to_RGB(h,s,v)\n"
	kbug(err,h,"h","number")
	kbug(err,s,"s","number")
	kbug(err,v,"v","number")
	local function para_range(t)
		if t<0
			then
			return t+1
		elseif t>1
			then
			return t-1
		else
			return t
		end
	end
	h=(h<360 and h or 0)
	if s==0
		then
		return v*255,v*255,v*255
	else
		local hi=math.floor(h/60)
		local f=h/60-hi
		local p=para_range(v*(1-s))
		local q=para_range(v*(1-f*s))
		local t=para_range(v*(1-(1-f)*s))
		if hi==0 or hi==6
			then
			return 255*v,255*t,255*p
		elseif hi==1
			then
			return 255*q,255*v,255*p
		elseif hi==2
			then
			return 255*p,255*v,255*t
		elseif hi==3
			then
			return 255*p,255*q,255*v
		elseif hi==4
			then
			return 255*t,255*p,255*v
		elseif hi==5
			then
			return 255*v,255*p,255*q
		end
	end
end

function HSV_to_HSL(h,s,v)
	local err="wrong input to function:Kcolor.HSV_to_HSL(h,s,v)\n"
	kbug(err,h,"h","number")
	kbug(err,s,"s","number")
	kbug(err,v,"v","number")
	local r,g,b=HSV_to_RGB1(h,s,v)
	local h,s,l=RGB_to_HSL(r,g,b)
	return h,s,l
end

function HSL_to_HSV(h,s,l)
	local err="wrong input to function:Kcolor.HSL_to_HSV(h,s,l)\n"
	kbug(err,h,"h","number")
	kbug(err,s,"s","number")
	kbug(err,l,"l","number")
	local r,g,b=HSL_to_RGB1(h,s,l)
	local h,s,v=RGB_to_HSV(r,g,b)
	return h,s,v
end

function get_HSV(color)
	local err="wrong input to function:Kcolor.get_HSV(color)\n"
	kbug(err,color,"color","string")
	local r,g,b=get_RGB(color)
	local h,s,v=RGB_to_HSV(r,g,b)
	return h,s,v
end

function get_HSL(color)
	local err="wrong input to function:Kcolor.get_HSL(color)\n"
	kbug(err,color,"color","string")
	local r,g,b=get_RGB(color)
	local h,s,l=RGB_to_HSL(r,g,b)
	return h,s,l
end

function color_tag_rgb(r,g,b)
	local str=string.format("&H%.2X%.2X%.2X&",b,g,r)
	return str
end

function color_tag(para1,para2,para3,mode)
	local err="wrong input to function:Kcolor.tag(para1,para2,para3,mode)\n"
	kbug(err,para1,"para1","number")
	kbug(err,para2,"para2","number")
	kbug(err,para3,"para3","number")
	mode=(mode and mode or "rgb")
	kbug(err,mode,"mode","string")
	mode=string.upper(mode)
	if mode=="RGB"
		then
		return color_tag_rgb(para1,para2,para3)
	elseif mode=="HSV"
		then
		local r,g,b=HSV_to_RGB1(para1,para2,para3)
		return color_tag_rgb(r,g,b)
	elseif mode=="HSL"
		then
		local r,g,b=HSL_to_RGB1(para1,para2,para3)
		return color_tag_rgb(r,g,b)
	else
		error("wrong input to function: color_tag(para1,prar2,para3,mode)\nmode only supports \"RGB\",\"HSV\",\"HSL\" \nplease input a correct mode")
	end
end

function interpolate_color_light(color,ph,ps,pl)--返回HSL百分比的ass颜色
	local r,g,b=get_RGB(color)
	local h,s,v=RGB_to_HSL(r,g,b)
	return ass_color(HSL_to_RGB(max(min(h*ph/100,360),0),max(min(s*ps/100,1),0),max(min(v*pl/100,1),0)))
end

function interpolate_color_light_HSV(color,ph,ps,pv)--返回HSV百分比的ass颜色
	local r,g,b=get_RGB(color)
	local h,s,v=RGB_to_HSV(r,g,b)
	return ass_color(HSV_to_RGB(max(min(h*ph/100,360),0),max(min(s*ps/100,1),0),max(min(v*pv/100,1),0)))
end

function color_gradient(color1,color2,t)
	local err="wrong input to function:Kcolor.gradient(color1,color2,t)\n"
	kbug(err,color1,"color1","string")
	kbug(err,color2,"color2","string")
	kbug(err,t,"t","number")
	local r1,g1,b1=get_RGB(color1)
	local r2,g2,b2=get_RGB(color2)
	local r,g,b=r1*(1-t)+r2*t,g1*(1-t)+g2*t,b1*(1-t)+b2*t
	return color_tag(r,g,b,"rgb")
end

function color_percent(color,pct1,pct2,pct3,mode)
	mode=(mode and mode or "rgb")
	local err="wrong input to function:Kcolor.percent(color,pct1,pct2,pct3,mode)\n"
	kbug(err,color,"color","string")
	kbug(err,pct1,"pct1","number")
	kbug(err,pct2,"pct2","number")
	kbug(err,pct3,"pct3","number")
	kbug(err,mode,"mode","string")
	mode=string.upper(mode)
	pct1,pct2,pct3=pct1/100,pct2/100,pct3/100
	if mode=="RGB"
		then
		local r,g,b=get_RGB(color)
		r,g,b=r*pct1,g*pct2,b*pct3
		return color_tag(r,g,b,"rgb")
	elseif mode=="HSV"
		then
		local h,s,v=get_HSV(color)
		h,s,v=h*pct1,s*pct2,v*pct3
		return color_tag(h,s,v,"hsv")
	elseif mode=="HSL"
		then
		local h,s,l=get_HSL(color)
		h,s,l=h*pct1,s*pct2,l*pct3
		return color_tag(h,s,l,"hsl")
	else
		error("wrong input to function:Kcolor.tag(para1,prar2,para3,mode)\nmode only supports \"RGB\",\"HSV\",\"HSL\" \nplease input a correct mode")
	end
end

function color_HSV(h,s,v)
	return ass_color(HSV_to_RGB(h,s,v))
end

------------------以下为三维投影相关定义--------------------------

function get_polar_pos(polar_shape)--table，返回三维图形命令点坐标
	local pos={}
	for x,y,z in polar_shape:gmatch("(-?[%d.]+) (-?[%d.]+) (-?[%d.]+)")
		do
		pos[#pos+1]={x=tonumber(x),y=tonumber(y),z=tonumber(z)}
	end
	return pos
end

TDS={shape={},tds={},ass={},plane={}}--TDS表初始化

--TDS.polar_to_plane=function (vector)
	--local x,y,z=vector[1][1],vector[1][2],vector[1][3]
	--local pos_x,pos_y=_G.num((y-x)*math.sqrt(3)/2,3),-_G.num(z-(x+y)/2,3)
	--return pos_x,pos_y
--end

TDS.polar_to_plane=function (vector)--number，三维向量投影到二维平面
	local x,y,z=vector[1][1],vector[1][2],vector[1][3]
	local x0,y0=y,z
	pos_x,pos_y=num(x0-x/sqrt(8),1),num(-y0+x/sqrt(8),1)
	return pos_x,pos_y
end

TDS.ass_or_tds=function (shape)--判断输入为三维或二维图形
	local num={}
	if type(shape)~="string"
		then
		error("shape is not a string value",2)
	else
		local vec=match(shape,"[a-z][^a-z]+")
		if (not vec)
			then
			error("shape is not a 2D or 3D shape",2)
		else
			local out=point_cut(vec," ")
			for i=1,#out
				do
				num[#num+1]=tonumber(out[i])
			end
		end
	end
	if ((#num)%3==0)
		then
		return 3
	else
		return 2
	end
end

TDS.polar_to_shape=function (polar_shape)--string，将三维图形转化为平面ass图形
	return gsub(polar_shape,"(-?[%d.]+) (-?[%d.]+) (-?[%d.]+)",
		function (x,y,z)
			x,y,z=tonumber(x),tonumber(y),tonumber(z)
			local x0,y0=TDS.polar_to_plane({{x,y,z}})
			return ""..x0.." "..y0
		end )
end

TDS.vec_to_shape=function (vec)--string，将向量集合转化为三维图形
	local shape=""
	for i=1,#vec
		do
		local x,y,z=vec[i][1][1],vec[i][1][2],vec[i][1][3]
		shape=shape..(i==1 and "m " or "l ")..num(x,1).." "..num(y,1).." "..num(z,1).." "
	end
	return shape
end

TDS.tds.vec_to_shape=function (vec,cmd,mode)--string，将向量集合按mode转化为图形
local str=""
if mode==2
	then
	for i=1,#vec
		do
		s_x,s_y=TDS.polar_to_plane(vec[i])
		str=str..(i==1 and cmd or "").." "..num(s_x,1).." "..num(s_y,1)
		end
	elseif (mode==3)
		then
		for i=1,#vec
			do
			local x,y,z=vec[i][1][1],vec[i][1][2],vec[i][1][3]
			str=str..(i==1 and cmd or "").." "..num(x,1).." "..num(y,1).." "..num(z,1)
		end
	else
		error("mode must be 2 or 3 and a number value",2)
	end
	return str
end

TDS.vector_normal=function (vector)--number，向量模
	local x,y,z=vector[1][1],vector[1][2],vector[1][3]
	return sqrt(pow(x,2)+pow(y,2)+pow(z,2))
end

TDS.inner_product=function (vector1,vector2)--number，向量点乘
	local x1,y1,z1,x2,y2,z2=vector1[1][1],vector1[1][2],vector1[1][3],vector2[1][1],vector2[1][2],vector2[1][3]
	return x1*x2+y1*y2+z1*z2
end

TDS.outer_product=function (vector1,vector2)--table，向量叉乘
	local x1,y1,z1,x2,y2,z2=vector1[1][1],vector1[1][2],vector1[1][3],vector2[1][1],vector2[1][2],vector2[1][3]
	return {{y1*z2-z1*y2,z1*x2-x1*z2,x1*y2-x2*y1}}
end

TDS.vector_angle=function (vector1,vector2)--number，向量夹角(角度制)
	local x1,y1,z1,x2,y2,z2=vector1[1][1],vector1[1][2],vector1[1][3],vector2[1][1],vector2[1][2],vector2[1][3]
	local len1,len2=sqrt(pow(x1,2)+pow(y1,2)+pow(z1,2)),sqrt(pow(x2,2)+pow(y2,2)+pow(z2,2))
	if (len1==0 or len2==0)
		then
			return 90
	else
		return math.deg(math.acos(TDS.inner_product(vector1,vector2)/(len1*len2)))
	end
end

TDS.plane.normal_vector=function (polar_shape)--table，平面法向量
	local pos=get_polar_pos(polar_shape)
	local x1,y1,z1=pos[1].x,pos[1].y,pos[1].z
	for i=2,#pos
		do
		local x2,y2,z2=pos[i].x,pos[i].y,pos[i].z
		if TDS.vector_normal({{x2-x1,y2-y1,z2-z1}})~=0
			then
				vector1={{x2-x1,y2-y1,z2-z1}}
			break
		end
	end
	for i=#pos,2,-1
		do
		local x3,y3,z3=pos[i].x,pos[i].y,pos[i].z
		if (TDS.vector_normal({{x3-x1,y3-y1,z3-z1}})~=0 and TDS.vector_angle(vector1,{{x3-x1,y3-y1,z3-z1}})~=0)
			then
				vector2={{x3-x1,y3-y1,z3-z1}}
			break
			end
		end
	return TDS.outer_product(vector1,vector2)
end

TDS.plane.line_angle=function (polar_shape,vector)--number，线面角(角度制，范围在0到90度之间)
	local p_nvec=TDS.plane.normal_vector(polar_shape)
	return (math.min(TDS.vector_angle(vector,p_nvec),180-TDS.vector_angle(vector,p_nvec)))
end

TDS.plane.dihedral_angle=function (polar_shape1,polar_shape2)--number，二面角(角度制，范围在0到180度之间)
	local p_nvec1,p_nvec2=TDS.plane.normal_vector(polar_shape1),TDS.plane.normal_vector(polar_shape2) 
	return TDS.vector_angle(p_nvec1,p_nvec2)
end

TDS.translate=function (vector,mx,my,mz)--table，三维空间坐标平移
	return {{vector[1][1]+mx,vector[1][2]+my,vector[1][3]+mz}}
end

TDS.rotate_x=function (vector,roll)--table，三维空间坐标旋转(x轴)
	roll=rad(roll)
	return matrix_multi_matrix(vector,{{1,0,0},{0,cos(roll),-sin(roll)},{0,sin(roll),cos(roll)}})
end

TDS.rotate_y=function (vector,pitch)--table，三维空间坐标旋转(y轴)
	pitch=rad(pitch)
	return matrix_multi_matrix(vector,{{cos(pitch),0,sin(pitch)},{0,1,0},{-sin(pitch),0,cos(pitch)}})
end

TDS.rotate_z=function (vector,yaw)--table，三维空间坐标旋转(z轴)
	yaw=rad(yaw)
	return matrix_multi_matrix(vector,{{cos(yaw),-sin(yaw),0},{sin(yaw),cos(yaw),0},{0,0,1}})
end

TDS.rotate=function (vector,roll,pitch,yaw,mode)--table，按模式三维空间坐标旋转
	if (type(mode)~="string" and type(mode)~="nil" and type(mode)~="boolean")
		then
		error("please input a correct rotate mode",2)
	else
		mode=mode and mode or "xyz"
	end
	if mode=="xyz"
		then
		return TDS.rotate_z(TDS.rotate_y(TDS.rotate_x(vector,roll),pitch),yaw)
	elseif mode=="xzy"
		then
		return TDS.rotate_y(TDS.rotate_z(TDS.rotate_x(vector,roll),yaw),pitch)
	elseif mode=="yxz"
		then
		return TDS.rotate_z(TDS.rotate_x(TDS.rotate_y(vector,pitch),roll),yaw)
	elseif mode=="yzx"
		then
		return TDS.rotate_x(TDS.rotate_z(TDS.rotate_y(vector,pitch),yaw),roll)
	elseif mode=="zxy"
		then
		return TDS.rotate_y(TDS.rotate_x(TDS.rotate_z(vector,yaw),roll),pitch)
	elseif mode=="zyx"
		then
		return TDS.rotate_x(TDS.rotate_y(TDS.rotate_z(vector,yaw),pitch),roll)
	else
		error("please input a correct rotate mode",2)
	end
end

TDS.rotate_org=function (vector,theta,l_vector)
	local rad=math.rad(theta)
	local nx,ny,nz=l_vector[1][1],l_vector[1][2],l_vector[1][3]
	mat={{math.pow(nx,2)*(1-math.cos(rad))+math.cos(rad),nx*ny*(1-math.cos(rad))-nz*math.sin(rad),nx*nz*(1-math.cos(rad))+ny*math.sin(rad)},
	{nx*ny*(1-math.cos(rad))+nz*math.sin(rad),math.pow(ny,2)*(1-math.cos(rad))+math.cos(rad),ny*nz*(1-math.cos(rad))-nx*math.sin(rad)},
	{nx*nz*(1-math.cos(rad))-ny*math.sin(rad),ny*nz*(1-math.cos(rad))+nx*math.sin(rad),math.pow(nz,2)*(1-math.cos(rad))+math.cos(rad)}}
	return matrix_multi_matrix(vector,mat)
end

TDS.scale=function (vector,sx,sy,sz)--table，三维空间坐标缩放
	local x,y,z=vector[1][1],vector[1][2],vector[1][3]
	return {{x*sx,y*sy,z*sz}}
end

TDS.normal_vector_scale=function (vector,sx,sy,sz)--table，法向量缩放变换
	local x,y,z=vector[1][1],vector[1][2],vector[1][3]
	return {{x*sy*sz,y*sx*sz,z*sx*sy}}
end

TDS.shape.filter=function (polar_shape,func,mode)
	local function filter(x,y,z)
		local x,y,z=func(x,y,z)
		x,y,z=tonumber(x),tonumber(y),tonumber(z)
		return ""..x.." "..y.." "..z
	end
	local str=gsub(polar_shape,"(-?[%d.]+) (-?[%d.]+) (-?[%d.]+)",filter)
	if mode==3
		then
		return str
	elseif mode==2
		then
		return TDS.polar_to_shape(str)
	else
		error("mode must be 2 or 3 and a number value",2)
	end
end

TDS.shape.translate=function (polar_shape,mx,my,mz,mode)--string,图形平移(mode决定三维或二维)
	return TDS.shape.filter(polar_shape,function(x,y,z) return x+mx,y+my,z+mz end,mode)
end

TDS.shape.rotate=function (polar_shape,pitch,roll,yaw,r_mode,mode)--string,图形旋转(mode决定三维或二维)
	local xr,yr,zr=pitch,roll,yaw
	return TDS.shape.filter(polar_shape,
		function(x,y,z)
			local vec=TDS.rotate({{x,y,z}},xr,yr,zr,r_mode)
			local nx,ny,nz=vec[1][1],vec[1][2],vec[1][3]
			return nx,ny,nz
		end
	,mode)
end

TDS.shape.rotate_org=function (polar_shape,theta,l_vector,mode)--string,图形旋转(mode决定三维或二维)
	local xr,yr,zr=pitch,roll,yaw
	return TDS.shape.filter(polar_shape,
		function(x,y,z)
			local vec=TDS.rotate_org({{x,y,z}},theta,l_vector)
			local nx,ny,nz=vec[1][1],vec[1][2],vec[1][3]
			return nx,ny,nz
		end
	,mode)
end

TDS.shape.scale=function (polar_shape,sx,sy,sz,mode)--string,图形缩放(mode决定三维或二维)
	local xr,yr,zr=pitch,roll,yaw
	return TDS.shape.filter(polar_shape,
		function(x,y,z)
			return x*sx,y*sy,z*sz
		end
	,mode)
end

TDS.shape.bounding=function (polar_shape)
	local i=0
	for x,y,z in gmatch(polar_shape,"(-?[%d.]+) (-?[%d.]+) (-?[%d.]+)")
		do
		i=i+1
		maxx=max(x,i==1 and x or maxx)
		maxy=max(y,i==1 and y or maxy)
		maxz=max(z,i==1 and z or maxz)
		minx=min(x,i==1 and x or minx)
		miny=min(y,i==1 and y or miny)
		minz=min(z,i==1 and z or minz)
	end
	return minx,miny,minz,maxx,maxy,maxz
end

TDS.ass_shape_to_tds=function(ass_shape,height,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode,mode)--string，二维图形转三维投影
	local str=gsub(ass_shape,"(-?[%d.]+) (-?[%d.]+)",function(x,y) return x.." "..y.." "..height end)
	return TDS.shape.scale(TDS.shape.translate(TDS.shape.rotate(str,roll,pitch,yaw,r_mode,3),x_off,y_off,z_off,3),sx,sy,sz,mode)
end

TDS.assvec_to_tdsvec_strech=function (vector,height)--string，二维命令z方向拉伸转三维命令
	local cmd=match(vector.str,"[a-z]")
	local pos=get_pos(vector.str)
	insert(pos.x,1,vector.sx)
	insert(pos.y,1,vector.sy)
	local tds={"","","",""}
	tds[1]="m "..vector.sx.." "..vector.sy.." "..height
	tds[3]="l "..pos.x[#pos.x].." "..pos.y[#pos.y].." 0"
	for i=2,4,2
		do
		for p=(i==2 and 2 or #pos.x-1),(i==2 and #pos.x or 1),(i==2 and 1 or -1)
			do
			tds[i]=tds[i]..(((i==2 and p==2) or (i==4 and p==#pos.x-1)) and (cmd=="b" and "b" or "l") or "").." "..pos.x[p].." "..pos.y[p].." "..(i==2 and height or 0)
		end
	end
	return concat(tds," ")
end

TDS.ass_to_tds_strech_single=function (ass_shape,height,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode)--table，单个二维图形侧面拉伸转三维投影
	local sur={}
	local ass_vec=shape.concavity(ass_shape)
	local num,dir=shape.measure(ass_shape)
	local vec_z={{0,0,dir and 1 or -1}}
	for i=1,#ass_vec
		do
		local pos=get_pos(ass_vec[i].str)
		local pos_prev=get_pos(ass_vec[fmod(i,#ass_vec)+1].str)
		local x,y=pos.x[#pos.x],pos.y[#pos.y]
		local s_x,s_y=pos_prev.x[#pos_prev.x],pos_prev.y[#pos_prev.y]
		if (not(s_x==x and s_y==y))
			then
			local vec_str={{x-s_x,y-s_y,0}}
			sur[#sur+1]={}
			sur[#sur].shape=TDS.assvec_to_tdsvec_strech({str=ass_vec[fmod(i,#ass_vec)+1].str,sx=x,sy=y},height)
			sur[#sur].vector=TDS.outer_product(vec_str,vec_z)
			sur[#sur].lay=(tostring(ass_vec[i].con)~="false" and 1 or 0)
		end
	end
	local top,t_vec=TDS.ass_shape_to_tds(ass_shape,height,0,0,0,0,0,0,1,1,1,false,3),{{0,0,1}}
	local bottom,b_vec=TDS.ass_shape_to_tds(ass_shape,0,0,0,0,0,0,0,1,1,1,false,3),{{0,0,-1}}
	sur[#sur+1],sur[#sur+2]={shape=top,vector=t_vec,lay=1,sur=true},{shape=bottom,vector=b_vec,lay=1,sur=true}
	return TDS.tds.preprocess(sur,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode)
end

TDS.ass_to_tds_strech=function (ass_shape,height,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode)--table，二维图形侧面拉伸转三维投影
	local sur={}
	for s in gmatch(ass_shape,"[m][^m]+")
		do
		sur=table.add(sur,TDS.ass_to_tds_strech_single(s,height,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode))
	end
	return sur
end

TDS.ass_to_tds_strech_text=function (text_shape,height,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode)--table，针对文字绘图纵向拉伸建模
	local sur={}
	local anti,clock=direction(text_shape)
	local num,dir=shape.measure(anti[1].shape)
	local vec_z={{0,0,dir and 1 or -1}}
	for i=1,#anti--非镂空部分建模
		do
		local ass_vec=_G.shape.concavity(anti[i].shape)
		for p=1,#ass_vec
			do
			local pos=get_pos(ass_vec[p].str)
			local pos_prev=get_pos(ass_vec[math.fmod(p,#ass_vec)+1].str)
			local x,y=pos.x[#pos.x],pos.y[#pos.y]
			local s_x,s_y=pos_prev.x[#pos_prev.x],pos_prev.y[#pos_prev.y]
			local vec_str={{x-s_x,y-s_y,0}}
			sur[#sur+1]={}
			sur[#sur].shape=TDS.assvec_to_tdsvec_strech({str=ass_vec[math.fmod(p,#ass_vec)+1].str,sx=x,sy=y},height)
			sur[#sur].vector=TDS.outer_product(vec_str,vec_z)
			sur[#sur].lay=(_G.tostring(ass_vec[p].con)~="false" and "out2" or "out1")
			sur[#sur].mea=anti[i].measure
		end
	end
	for i=1,#clock--镂空部分建模
		do
		local ass_vec=_G.shape.concavity(clock[i].shape)
		for p=1,#ass_vec
			do
			local pos=get_pos(ass_vec[p].str)
			local pos_prev=get_pos(ass_vec[math.fmod(p,#ass_vec)+1].str)
			local x,y=pos.x[#pos.x],pos.y[#pos.y]
			local s_x,s_y=pos_prev.x[#pos_prev.x],pos_prev.y[#pos_prev.y]
			local vec_str={{x-s_x,y-s_y,0}}
			sur[#sur+1]={}
			sur[#sur].shape=TDS.assvec_to_tdsvec_strech({str=ass_vec[math.fmod(p,#ass_vec)+1].str,sx=x,sy=y},height)
			sur[#sur].vector=TDS.outer_product(vec_str,vec_z)
			sur[#sur].lay=(_G.tostring(ass_vec[p].con)~="false" and "in1" or "in0")
			sur[#sur].mea=clock[i].measure
		end
	end
	local top,t_vec=TDS.ass_shape_to_tds(text_shape,height,0,0,0,0,0,0,1,1,1,false,3),{{0,0,1}}
	local bottom,b_vec=TDS.ass_shape_to_tds(text_shape,0,0,0,0,0,0,0,1,1,1,false,3),{{0,0,-1}}
	sur[#sur+1],sur[#sur+2]={shape=top,vector=t_vec,lay=1,mea=_G.shape.measure_text(text_shape)},{shape=bottom,vector=b_vec,lay=1,mea=_G.shape.measure_text(text_shape)}
	return TDS.tds.preprocess(sur,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode)
end

TDS.ass_to_tds_strech_united=function (ass_shape,height,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz)--string，二维图形侧面拉伸转三维投影并组合
	local sur={}
	for s in string.gmatch(ass_shape,"[m][^m]+")
		do
		sur=_G.table.add(sur,TDS.ass_to_tds_strech_single(s,height,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz))
	end
	return _G.table.concat(sur," ")
end

TDS.assvec_to_tds_pyramid=function (assvec1,assvec2,x0,y0,z0)
	local spos=get_pos(assvec1)
	local epos=get_pos(assvec2)
	local sx,sy,ex,ey=spos.x[#spos.x],spos.y[#spos.y],epos.x[#epos.x],epos.y[#epos.y]
	local tri=string.format("m %d %d %d l %d %d %d l %d %d %d ",x0,y0,z0,sx,sy,0,ex,ey,0)
	local n1={{x0-sx,y0-sy,z0}}
	local n2={{ex-sx,ey-sy,0}}
	n_vec=TDS.outer_product(n1,n2)
	if (not (sx==ex and sy==ey))
		then
		return tri,n_vec
	else
		return false
	end
end

TDS.shape.surface=function(ps,vec1)
	local angle_vis=rad(18.6) 
	local angle_theta=rad(19.6)
	local vec={{cos(angle_theta)*cos(angle_vis),sin(angle_theta)*cos(angle_vis),sin(angle_vis)}}
	local k,sux,suy,suz=0,0,0,0
	local rad1=math.rad(TDS.vector_angle(vec,vec1))
	for x,y,z in ps:gmatch("([-%d.]+) ([-%d.]+) ([-%d.]+)")
		do
		k=k+1
		sux,suy,suz=sux+x,suy+y,suz+z
	end
	return (sux*vec[1][1]+suy*vec[1][2]+suz*vec[1][3])*(math.sin(rad1)),(sux*vec[1][1]+suy*vec[1][2]+suz*vec[1][3])
end

TDS.strech=function(ass_shape,height,z_off)
	local function shape_rank(ass_shape)
		ass_shape=shape.close(ass_shape)
		local tbl={}
		local vec1={{0,0,1}}
		for s in ass_shape:gmatch("m[^m]+")
			do
			tbl[#tbl+1]=s
		end
		table.sort(tbl,function(a,b) local x1,y1,x2,y2=shape.bounding_real(a) local x3,y3,x4,y4=shape.bounding_real(a) return (x1+x2)<(x3+x4) end)
		return table.concat(tbl)
	end
	ass_shape=shape_rank(ass_shape)
	local t=TDS.ass_shape_to_tds(ass_shape,height,0,0,0,0,0,0,1,1,1,false,3)
	local t1=TDS.shape.translate(t,0,0,z_off,3)
	local t2=TDS.shape.translate(t,0,0,-height+z_off,3)
	local surface={}
	local function single(ass_shape)
		local _,jud=shape.measure(ass_shape)
		local vec0=(jud and {{0,0,-1}} or {{0,0,1}})
		while(true)
			do
			local x,y,v=ass_shape:match("([-%d.]+) ([-%d.]+) ([a-z][^a-z]+)")
			ass_shape=ass_shape:gsub("[a-z][^a-z]+","",1)
			if x and y and v
				then
				local pos=get_pos(v)
				local ex,ey=pos.x[1],pos.y[1]
				x,y=tonumber(x),tonumber(y)
				local s="m "..x.." "..y.." 0 l "..ex.." "..ey.." 0 l "..ex.." "..ey.." "..height.." l "..x.." "..y.." "..height.." "
				surface[#surface+1]={shape=TDS.shape.translate(s,0,0,z_off,3),vector=TDS.outer_product({{ex-x,ey-y,0}},vec0)}
				surface[#surface].layer=TDS.shape.surface(surface[#surface].shape,{{0,0,1}})
			else
				break
			end
		end
	end
	for s in ass_shape:gmatch("m[^m]+")
		do
		single(s)
	end
	surface[#surface+1]={shape=t1,vector={{0,0,1}},layer=TDS.shape.surface(t1,{{0,0,1}}),top=true}
	surface[#surface+1]={shape=t2,vector={{0,0,-1}},layer=TDS.shape.surface(t2,{{0,0,-1}}),top=true}
	table.sort(surface,function(a,b) return a.layer>b.layer end)
	return surface
end

TDS.strech_text=function(ass_shape,height,z_off)
	ass_shape=shape.close(ass_shape)
	local anti,clock=direction(ass_shape)
	local outshape=assemble(ass_shape)
	local _,jud=shape.measure(anti[1].shape)
	local vec0=(jud and {{0,0,-1}} or {{0,0,1}})
	local t=TDS.ass_shape_to_tds(ass_shape,height,0,0,0,0,0,0,1,1,1,false,3)
	local t1=TDS.shape.translate(t,0,0,z_off,3)
	local t2=TDS.shape.translate(t,0,0,-height+z_off,3)
	local surface={}
	local function single(ass_shape1,mode)
		while(true)
			do
			local x,y,v=ass_shape1:match("([-%d.]+) ([-%d.]+) ([a-z][^a-z]+)")
			ass_shape1=ass_shape1:gsub("[a-z][^a-z]+","",1)
			if x and y and v
				then
				local pos=get_pos(v)
				local ex,ey=pos.x[1],pos.y[1]
				x,y=tonumber(x),tonumber(y)
				local s="m "..x.." "..y.." 0 l "..ex.." "..ey.." 0 l "..ex.." "..ey.." "..height.." l "..x.." "..y.." "..height.." "
				surface[#surface+1]={shape=TDS.shape.translate(s,0,0,z_off,3),vector=TDS.outer_product({{ex-x,ey-y,0}},vec0),outer=(mode=="anti"),mea=math.distance(ex-x,ey-y)*height}
				surface[#surface].layer=TDS.shape.surface(surface[#surface].shape)
			else
				break
			end
		end
	end
	for i=1,#clock
		do
		single(clock[i].shape,"clock")
	end
	for i=1,#anti
		do
		single(anti[i].shape,"anti")
	end
	surface[#surface+1]={shape=t1,vector={{0,0,1}},layer=TDS.shape.surface(t1),top=true}
	surface[#surface+1]={shape=t2,vector={{0,0,-1}},layer=TDS.shape.surface(t2),top=true}
	return surface
end

TDS.tds.main_strech=function (surface,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode,duration,ms,color,vec_light,light_str,nature_light)--table，动态几何体生成主函数
	local max_r=TDS.tds.get_bound(surface)
	local len=#surface
	local tbl={}
	local light_str=(light_str and light_str or 1)
	local nature_light=(nature_light and nature_light or 0.01)
	local c_set={}
	if type(color)=="table"
		then 
		c_set=color
	elseif type(color)=="string"
		then
		for i=1,#surface
			do
			c_set[i]=color
		end
	else
		for i=1,#surface
			do
			c_set[i]="&HFFFFFF&"
		end
	end
	local angle_vis=rad(18.6) 
	local angle_theta=rad(19.6)
	local vec0={{2*cos(angle_theta)*cos(angle_vis),2*sin(angle_theta)*cos(angle_vis),2*sin(angle_vis)}}
	local vec_light=(vec_light and vec_light or {{-vec0[1][1],-vec0[1][2],-vec0[1][3]}})
	local outsur={}
	local max_n=ceil(duration/ms)
	for i=1,max_n
		do
		outsur[i]={}
		outsur[i].color={}
		outsur[i].alpha={}
		outsur[i].blur={}
		outsur[i].pos={}
		outsur[i].lay={}
		for p=1,#surface
			do
			local sur_vec=TDS.rotate(TDS.normal_vector_scale(surface[p].vector,1+(sx-1)*i/max_n,1+(sy-1)*i/max_n,1+(sz-1)*i/max_n),i*roll/max_n,i*pitch/max_n,i*yaw/max_n,r_mode)
			if TDS.vector_angle(sur_vec,vec0)<=90
				then
				local angle=TDS.vector_angle(sur_vec,vec0)
				local rad0=rad(TDS.vector_angle(sur_vec,vec0))
				local rad1=rad(TDS.vector_angle(sur_vec,vec_light))
				outsur[i][#outsur[i]+1]=TDS.shape.translate(TDS.shape.rotate(TDS.shape.scale(surface[p].shape,1+(sx-1)*i/max_n,1+(sy-1)*i/max_n,1+(sz-1)*i/max_n,3),i*roll/max_n,i*pitch/max_n,i*yaw/max_n,r_mode,3),i*x_off/max_n,i*y_off/max_n,i*z_off/max_n,3)
				outsur[i].color[#outsur[i].color+1]=interpolate_color_light(c_set[p],100,100,100*(light_str*abs(cos(rad1),0)+nature_light))
				outsur[i].alpha[#outsur[i].alpha+1]=ass_alpha(255-255*abs(cos(rad1)))
				outsur[i].pos[#outsur[i].pos+1]={}
				local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(outsur[i][#outsur[i]])
				local x0,y0,z0=(x1+x2)/2,(y1+y2)/2,(z1+z2)/2
				local lx,ly,lz=len*vec0[1][1],3*len*vec0[1][2],3*len*vec0[1][3]
				local ksur=TDS.shape.surface(outsur[i][#outsur[i]],sur_vec)
				outsur[i].lay[#outsur[i].lay+1]=num(2*#surface*(ksur+#surface*max_r+(surface[p].top and #surface*max_r or 0))/max_r)
				if type(surface[p].outer)=="boolean"
					then
					outsur[i].lay[#outsur[i].lay]=outsur[i].lay[#outsur[i].lay]+(surface[p].mea*ksur)/(2*max_r^2)
				end
			end
		end
	end
	for i=1,#outsur
		do
		tbl[i]=#outsur[i]
	end
	return outsur,loop_n2(tbl),tbl
end

TDS.ass_to_tds_pyramid_single=function (ass_shape,x0,y0,z0,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode)
	local sur={}
	local num,dir=shape.measure(ass_shape)
	local mul=(dir and 1 or -1)
	local b=TDS.ass_shape_to_tds(ass_shape,0,0,0,0,0,0,0,1,1,1,"xyz",3)
	local vec=shape.concavity(ass_shape)
	for i=1,#vec
		do
		local jud=TDS.assvec_to_tds_pyramid(vec[i].str,vec[math.fmod(i,#vec)+1].str,x0,y0,z0)
		if jud
			then
			s,v=TDS.assvec_to_tds_pyramid(vec[i].str,vec[math.fmod(i,#vec)+1].str,x0,y0,z0)
			sur[#sur+1]={shape=s,vector=matrix_multi_number(v,mul),lay=vec[i].con and 1 or 0}
		end
	end
	sur[#sur+1]={shape=b,vector={{0,0,-1}},lay=1}
	return TDS.tds.preprocess(sur,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode)
end

TDS.tds.preprocess=function (vector,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode)--table，三维图形表预处理
	local new_vector=table.copy_deep(vector,new_vector)
	for i=1,#vector
		do
		new_vector[i].shape=TDS.shape.translate(TDS.shape.rotate(TDS.shape.scale(new_vector[i].shape,sx,sy,sz,3),roll,pitch,yaw,r_mode,3),x_off,y_off,z_off,3)
		new_vector[i].vector=TDS.normal_vector_scale(TDS.rotate(new_vector[i].vector,roll,pitch,yaw,r_mode),sx,sy,sz)
	end
	return new_vector
end

TDS.ass_to_tbl=function(tbl)
	local new_tbl={}
	for i=1,#tbl
		do
		new_tbl[#new_tbl+1]={shape=TDS.ass_shape_to_tds(tbl[i],0,0,0,0,0,0,0,1,1,1,false,3),vector={{0,0,1}}}
	end
	return new_tbl
end

TDS.tds.dissect=function(surface,filter,duration,ms,point)
	local sur={}
	local angle_vis=rad(18.6) 
	local angle_theta=rad(19.6)
	local vec0={{2*cos(angle_theta)*cos(angle_vis),2*sin(angle_theta)*cos(angle_vis),2*sin(angle_vis)}}
	local max_n=math.ceil(duration/ms)
	for i=1,max_n
		do
		sur[i]={}
		for p=1,#surface
			do
			local s=TDS.shape.filter(surface[p].shape,function(x,y,z) return filter(x,y,z,i,max_n) end,3)
			local vec=TDS.plane.normal_vector(s)
			local angle=TDS.vector_angle(vec,vec0)
			sur[i][p]={shape=s,alpha=alpha_tag(math.abs(255*math.cos(math.rad(angle))))}
		end
	end
	if point
		then
		pos={}
		for i=1,max_n
			do
			pos[i]={}
			for p=1,#point
				do
				local x,y,z=point[p].x,point[p].y,0
				local nx,ny,nz=filter(x,y,z,i,max_n)
				local x1,y1=TDS.polar_to_plane({{nx,ny,nz}})
				pos[i][p]={x=x1,y=y1}
			end
		end
	end
	return sur,pos
end

TDS.tds.get_bound=function (surface)--number，计算图形表内图形位置最大值
	for i=1,#surface
		do
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
		local x0,y0,z0=(x1+x2)/2,(y1+y2)/2,(z1+z2)/2
		local r=sqrt(pow(x0,2)+pow(y0,2)+pow(z0,2))
		max_r=max(i==1 and r or max_r,r)
	end
	return num(max_r)
end

TDS.tds.main=function (surface,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode,duration,ms,color,vec_light,light_str,nature_light)--table，动态几何体生成主函数
	local max_r=TDS.tds.get_bound(surface)
	local len=#surface
	local tbl={}
	local light_str=(light_str and light_str or 1)
	local nature_light=(nature_light and nature_light or 0.01)
	local c_set={}
	if type(color)=="table"
		then 
		c_set=color
	elseif type(color)=="string"
		then
		for i=1,#surface
			do
			c_set[i]=color
		end
	else
		for i=1,#surface
			do
			c_set[i]="&HFFFFFF&"
		end
	end
	local angle_vis=rad(18.6) 
	local angle_theta=rad(19.6)
	local vec0={{2*cos(angle_theta)*cos(angle_vis),2*sin(angle_theta)*cos(angle_vis),2*sin(angle_vis)}}
	local vec_light=(vec_light and vec_light or {{-vec0[1][1],-vec0[1][2],-vec0[1][3]}})
	local outsur={}
	local max_n=ceil(duration/ms)
	for i=1,max_n
		do
		outsur[i]={}
		outsur[i].color={}
		outsur[i].alpha={}
		outsur[i].blur={}
		outsur[i].pos={}
		outsur[i].lay={}
		for p=1,#surface
			do
			local sur_vec=TDS.rotate(TDS.normal_vector_scale(surface[p].vector,1+(sx-1)*i/max_n,1+(sy-1)*i/max_n,1+(sz-1)*i/max_n),i*roll/max_n,i*pitch/max_n,i*yaw/max_n,r_mode)
			if TDS.vector_angle(sur_vec,vec0)<=90
				then
				local angle=TDS.vector_angle(sur_vec,vec0)
				local rad0=rad(TDS.vector_angle(sur_vec,vec0))
				local rad1=rad(TDS.vector_angle(sur_vec,vec_light))
				outsur[i][#outsur[i]+1]=TDS.shape.translate(TDS.shape.rotate(TDS.shape.scale(surface[p].shape,1+(sx-1)*i/max_n,1+(sy-1)*i/max_n,1+(sz-1)*i/max_n,3),i*roll/max_n,i*pitch/max_n,i*yaw/max_n,r_mode,3),i*x_off/max_n,i*y_off/max_n,i*z_off/max_n,3)
				outsur[i].color[#outsur[i].color+1]=interpolate_color_light(c_set[p],100,100,100*(light_str*abs(cos(rad1),0)+nature_light))
				outsur[i].alpha[#outsur[i].alpha+1]=ass_alpha(255-255*abs(cos(rad1)))
				outsur[i].pos[#outsur[i].pos+1]={}
				local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(outsur[i][#outsur[i]])
				local x0,y0,z0=(x1+x2)/2,(y1+y2)/2,(z1+z2)/2
				local lx,ly,lz=len*vec0[1][1],3*len*vec0[1][2],3*len*vec0[1][3]
				outsur[i].lay[#outsur[i].lay+1]=(lx+ly+lz+6*(x0+max_r)*len*vec0[1][1]/(2*max_r))+(surface[p].lay==0 and -5*cos(rad0) or 5*cos(rad0))+(4*(y0+max_r)*len*vec0[1][2]/(2*max_r))+(3*(z0+max_r)*len*vec0[1][3]/(2*max_r))+(surface[p].sur and 12*len or 0)
			end
		end
	end
	for i=1,#outsur
		do
		tbl[i]=#outsur[i]
	end
	return outsur,loop_n2(tbl),tbl
end

TDS.tds.main_static=function (surface,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode,color,vec_light,light_str,nature_light)--table，静态几何体生成函数
	local c_set={}
	local light_str=(light_str and light_str or 0.5)
	local nature_light=(nature_light and nature_light or 0.01)
	if type(color)=="table"
		then 
		c_set=color
	elseif type(color)=="string"
		then
		for i=1,#surface
			do
			c_set[i]=color
		end
	else
		for i=1,#surface
			do
			c_set[i]="HFFFFFF"
		end
	end
	local angle_vis=rad(18.6) 
	local angle_theta=rad(19.6)
	local vec0={{2*cos(angle_theta)*cos(angle_vis),2*sin(angle_theta)*cos(angle_vis),2*sin(angle_vis)}}
	local vec_light=(vec_light and vec_light or {{-vec0[1][1],-vec0[1][2],-vec0[1][3]}})
	local outsur={}
	for i=1,#surface
		do
		local n_vec=TDS.rotate(TDS.normal_vector_scale(surface[i].vector,sx,sy,sz),roll,pitch,yaw,r_mode)
		local theta=TDS.vector_angle(n_vec,vec0)
		if theta<90
			then
			local rad0=rad(theta)
			local rad1=rad(TDS.vector_angle(n_vec,vec_light))
			outsur[#outsur+1]={shape,color,alpha}
			outsur[#outsur].shape=TDS.shape.translate(TDS.shape.rotate(TDS.shape.scale(surface[i].shape,sx,sy,sz,3),roll,pitch,yaw,r_mode,3),x_off,y_off,z_off,3)
			outsur[#outsur].color=interpolate_color_light(c_set[i],100,100,math.min(100*(light_str*abs(cos(rad1))+nature_light),100))
			outsur[#outsur].alpha=ass_alpha(255/4+(255/4)*cos(rad1))
		end
	end
	return outsur
end


TDS.tds.main_text=function (surface,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode,duration,ms,color,vec_light,light_str,nature_light)--table，动态文字纵向拉伸几何体生成主函数
	local tbl={}
	local c_set={}
	local light_str=(light_str and light_str or 0.5)
	local nature_light=(nature_light and nature_light or 0.01)
	if _G.type(color)=="table"
		then 
		c_set=color
	elseif _G.type(color)=="string"
		then
		for i=1,#surface
			do
			c_set[i]=color
		end
	else
		for i=1,#surface
			do
			c_set[i]="&HFFFFFF&"
		end
	end
	local angle_vis=rad(18.6) 
	local angle_theta=rad(19.6)
	local vec0={{2*cos(angle_theta)*cos(angle_vis),2*sin(angle_theta)*cos(angle_vis),2*sin(angle_vis)}}
	local vec_light=(vec_light and vec_light or vec0)
	local outsur={}
	local max_n=ceil(duration/ms)
	for i=1,max_n
		do
		outsur[i]={}
		outsur[i].color={}
		outsur[i].alpha={}
		outsur[i].blur={}
		outsur[i].pos={}
		outsur[i].lay={}
		for p=1,#surface
			do
			local sur_vec=TDS.normal_vector_scale(TDS.rotate(surface[p].vector,i*roll/max_n,i*pitch/max_n,i*yaw/max_n,r_mode),1+(sx-1)*i/max_n,1+(sy-1)*i/max_n,1+(sz-1)*i/max_n)
			if TDS.vector_angle(sur_vec,vec0)<90
				then
				local angle=TDS.vector_angle(sur_vec,vec0)
				local rad0=rad(angle)
				outsur[i][#outsur[i]+1]=TDS.shape.translate(TDS.shape.rotate(TDS.shape.scale(surface[p].shape,1+(sx-1)*i/max_n,1+(sy-1)*i/max_n,1+(sz-1)*i/max_n,3),i*roll/max_n,i*pitch/max_n,i*yaw/max_n,r_mode,3),i*x_off/max_n,i*y_off/max_n,i*z_off/max_n,3)
				outsur[i].frame_n,outsur[i].color[#outsur[i].color+1]=i,interpolate_color_light(c_set[p],100,100,100*abs(cos(rad0)))
				outsur[i].alpha[#outsur[i].alpha+1]=ass_alpha(255*abs(cos(rad0)))
				outsur[i].pos[#outsur[i].pos+1]={}
				local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(outsur[i][#outsur[i]])
				local x0,y0,z0=(x1+x2)/2,(y1+y2)/2,(z1+z2)/2
				local me=surface[p].mea
				local s_set=(p>=#surface-1 and 2000 or 0)
				local len=#surface
				local lx,ly,lz=len*vec0[1][1],len*vec0[1][2],len*vec0[1][3]
				local px,py,pz=x0*vec0[1][1],y0*vec0[1][2],z0*vec0[1][3]
				outsur[i].lay[#outsur[i].lay+1]=(surface[p].lay=="out2" and floor(700-5*cos(rad0)+me/30+px+py+pz+s_set) or (surface[p].lay=="out1") and floor(600-5*cos(rad0)+x0*vec0[1][1]+y0*vec0[1][2]+z0*vec0[1][3]+me/40+s_set) or (surface[p].lay=="in1") and floor(80+5*cos(rad0)+x0*vec0[1][1]+y0*vec0[1][2]+z0*vec0[1][3]+me/50+s_set) or  floor(40+5*cos(rad0)+x0*vec0[1][1]+y0*vec0[1][2]+z0*vec0[1][3]+me/60+s_set))
			end
		end
	end
	for i=1,#outsur
		do
		tbl[i]=#outsur[i]
	end
	return outsur,loop_n2(tbl)
end

TDS.tds.main_alpha=function (surface,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode,duration,ms,color,vec_light,light_str,nature_light)
	local tbl={}
	local c_set={}
	local light_str=(light_str and light_str or 0.5)
	local nature_light=(nature_light and nature_light or 0.01)
	if type(color)=="table"
		then 
		c_set=color
	elseif type(color)=="string"
		then
		for i=1,#surface
			do
			c_set[i]=color
		end
	else
		for i=1,#surface
			do
			c_set[i]="&HFFFFFF&"
		end
	end
	local angle_vis=rad(18.6) 
	local angle_theta=rad(19.6)
	local vec0={{2*cos(angle_theta)*cos(angle_vis),2*sin(angle_theta)*cos(angle_vis),2*sin(angle_vis)}}
	local vec_light=(vec_light and vec_light or vec0)
	local outsur={}
	local max_n=ceil(duration/ms)
	for i=1,max_n
		do
		outsur[i]={}
		outsur[i].color={}
		outsur[i].alpha={}
		outsur[i].blur={}
		outsur[i].pos={}
		outsur[i].lay={}
		for p=1,#surface
			do
			local sur_vec=TDS.rotate(TDS.normal_vector_scale(surface[p].vector,1+(sx-1)*i/max_n,1+(sy-1)*i/max_n,1+(sz-1)*i/max_n),i*roll/max_n,i*pitch/max_n,i*yaw/max_n,r_mode)
			local angle=TDS.vector_angle(sur_vec,vec0)
			local rad1=rad(TDS.vector_angle(sur_vec,vec_light))
			outsur[i][#outsur[i]+1]=TDS.shape.translate(TDS.shape.rotate(TDS.shape.scale(surface[p].shape,1+(sx-1)*i/max_n,1+(sy-1)*i/max_n,1+(sz-1)*i/max_n,3),i*roll/max_n,i*pitch/max_n,i*yaw/max_n,r_mode,3),i*x_off/max_n,i*y_off/max_n,i*z_off/max_n,3)
			outsur[i].color[#outsur[i].color+1]=interpolate_color_light(c_set[p],100,100,100*(light_str*abs(cos(rad1))+nature_light))
			outsur[i].alpha[#outsur[i].alpha+1]=ass_alpha(math.abs(255*cos(rad1)))
			outsur[i].lay[#outsur[i].lay+1]=(cos(rad(angle))>=0 and 1 or 0)
		end
	end
	for i=1,#outsur
		do
		tbl[i]=#outsur[i]
	end
	return outsur,loop_n2(tbl),tbl
end

TDS.tds.main_alpha_static=function (surface,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,r_mode,color,vec_light)
	local c_set={}
	if _G.type(color)=="table"
		then 
		c_set=color
	elseif _G.type(color)=="string"
		then
		for i=1,#surface
			do
			c_set[i]=color
		end
	else
		for i=1,#surface
			do
			c_set[i]="HFFFFFF"
		end
	end
	local angle_vis=rad(18.6) 
	local angle_theta=rad(19.6)
	local vec0={{2*cos(angle_theta)*cos(angle_vis),2*sin(angle_theta)*cos(angle_vis),2*sin(angle_vis)}}
	local vec_light=(vec_light and vec_light or vec0)
	local outsur={}
	for i=1,#surface
		do
		local n_vec=TDS.rotate(TDS.normal_vector_scale(surface[i].vector,sx,sy,sz),roll,pitch,yaw,r_mode)
		local theta=TDS.vector_angle(n_vec,vec0)
		local rad0=rad(theta)
		outsur[#outsur+1]={shape,color,alpha}
		outsur[#outsur].shape=TDS.shape.translate(TDS.shape.rotate(TDS.shape.scale(surface[i].shape,sx,sy,sz,3),roll,pitch,yaw,r_mode,3),x_off,y_off,z_off,3)
		outsur[#outsur].color=interpolate_color_light(c_set[i],100,100,50+50*cos(rad0))
		outsur[#outsur].alpha=_G.ass_alpha(255/2-(255/2)*cos(rad0))
		outsur[#outsur].lay=(theta>90 and 0 or 1)
	end
	return outsur
end

TDS.tds.main_surface=function (surface,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,duration,ms,color)
	local new_sur={}
	local angle_vis=math.rad(20) 
	local angle_theta=math.rad(20)
	local vec0={{2*math.cos(angle_theta)*math.cos(angle_vis),2*math.sin(angle_theta)*math.cos(angle_vis),2*math.sin(angle_vis)}}
	for i=1,#surface
		do
		local sur_vec=TDS.normal_vector_scale(TDS.rotate(surface[i].vector,roll,pitch,yaw),sx,sy,sz)
		local sur0=TDS.shape.translate(TDS.shape.rotate(TDS.shape.scale(surface[i].shape,sx,sy,sz,3),roll,pitch,yaw,3),x_off,y_off,z_off,2)
		local x1,y1,x2,y2=_G.shape.bounding_real(sur0)
		local angle=math.rad(TDS.vector_angle(vec0,sur_vec))
		new_sur[i]={}
		new_sur[i].x,new_sur[i].y=(x1+x2)/2,(y1+y2)/2
		new_sur[i].shape=_G.shape.translate(sur0,-(x1+x2)/2,-(y1+y2)/2)
		new_sur[i].alpha=_G.ass_alpha(255*math.abs(math.cos(angle)))
	end
	return new_sur
end

TDS.tds.surface=function (sur,pct)
	local new_tbl={}
	local tbl=sur[math.ceil(pct*#sur/100)]
	for i=1,#tbl
		do
		local s0=TDS.polar_to_shape(sur[i])
		local x1,y1,x2,y2=shape.bounding_real(s0)
		local x0,y0=(x1+x2)/2,(y1+y2)/2
		new_tbl[#new_tbl+1]={shape=Kshape.move(s0,-x0,-y0),x=x0,y=y0}
	end
	return new_tbl
end

TDS.tds.main_surface_first=function (surface,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz,duration,ms,color)
	local new_sur={}
	local angle_vis=math.rad(20) 
	local angle_theta=math.rad(20)
	local vec0={{2*math.cos(angle_theta)*math.cos(angle_vis),2*math.sin(angle_theta)*math.cos(angle_vis),2*math.sin(angle_vis)}}
	for i=1,#surface
		do
		local sur_vec=TDS.rotate(surface[i].vector,0,0,0)
		local sur0=TDS.shape.translate(TDS.shape.rotate(TDS.shape.scale(surface[i].shape,1,1,1,3),0,0,0,3),0,0,0,2)
		local x1,y1,x2,y2=_G.shape.bounding_real(sur0)
		local angle=math.rad(TDS.vector_angle(vec0,sur_vec))
		new_sur[i]={}
		new_sur[i].x,new_sur[i].y=(x1+x2)/2,(y1+y2)/2
		new_sur[i].shape=_G.shape.translate(sur0,-(x1+x2)/2,-(y1+y2)/2)
		new_sur[i].alpha=_G.ass_alpha(255*math.abs(math.cos(angle)))
	end
	return new_sur
end

TDS.tds.plane_preprocess=function (shape_tbl,height,vec)--table，将二维图形集合转换为三维图形集合
	local surface={}
	for i=1,#shape_tbl
		do
		local sur_shape=TDS.ass_shape_to_tds(shape_tbl[i],height,0,0,0,0,0,0,1,1,1,false,3)
		surface[i]={shape=sur_shape,vector=vec}
	end
	return surface
end

TDS.tds.filter=function (surface,func)
	for i=1,#surface
		do
		surface[i].shape=TDS.shape.filter(surface[i].shape,func)
		local vec0=TDS.plane.normal_vector(surface[i].shape)
		surface[i].vector=matrix_multi_number(vec0,vec0[1][3]>0 and 1 or 0)
	end
	return surface
end

TDS.tds.triangle_tds=function (surface,point,rad_x,rad_y,rad_z,length,width,x_A,y_A,z_A,duration,ms,tbl)
	tbl=(tbl and tbl or {0,0,0,0,0,0,1,1,1})
	local rad_x_off,rad_y_off=math.ceil(length/200)*math.pi,math.ceil(width/200)*math.pi
	local sur,pos={},{}
	local angle_vis=math.rad(20) 
	local angle_theta=math.rad(20)
	local vec0={{2*math.cos(angle_theta)*math.cos(angle_vis),2*math.sin(angle_theta)*math.cos(angle_vis),2*math.sin(angle_vis)}}
	local max_n=math.ceil(duration/ms)
	for i=1,max_n
		do
		sur[i]={}
		sur[i].alpha={}
		sur[i].layer={}
		sur[i].color={}
		for p=1,#surface
			do
			sur[i][p]=TDS.shape.rotate(TDS.shape.scale(TDS.shape.filter(surface[p].shape,
				function (x,y,z)
				math.randomseed(x)
				local x_off,y_off,z_off=math.random(-tbl[1],tbl[1]),math.random(-tbl[2],tbl[2]),math.random(-tbl[3],tbl[3])
				return
				num(x+x_off*i/max_n+x_A*math.sin(i*rad_x/max_n+y*rad_y_off/width)),
				num(y+y_off*i/max_n+y_A*math.sin(i*rad_y/max_n+x*rad_x_off/length)),
				num(z+z_off*i/max_n+z_A*math.sin(i*rad_z/max_n+y*rad_y_off/width+x*rad_x_off/length))
				end
				,3),1+i*(tbl[7]-1)/max_n,1+i*(tbl[8]-1)/max_n,1+i*(tbl[9]-1)/max_n,3),i*tbl[4]/max_n,i*tbl[5]/max_n,i*tbl[6]/max_n,false,3)
			local vec_dt=TDS.plane.normal_vector(sur[i][p])
			vec_dt=matrix_multi_number(vec_dt,(vec_dt[1][3]>0 and 1 or -1))
			local angle=math.rad(TDS.vector_angle(vec0,vec_dt))
			sur[i].alpha[p]=_G.ass_alpha(255*math.abs(math.cos(angle)))
		end
	end
	for i=1,max_n
		do
		pos[i]={}
		for p=1,#point
			do
			math.randomseed(point[p].x)
			local x_off,y_off,z_off=math.random(-tbl[1],tbl[1]),math.random(-tbl[2],tbl[2]),math.random(-tbl[3],tbl[3])
			local x,y,z=
				num(point[p].x+x_off*i/max_n+x_A*math.sin(i*rad_x/max_n+point[p].y*rad_y_off/width)),
				num(point[p].y+y_off*i/max_n+y_A*math.sin(i*rad_y/max_n+point[p].x*rad_x_off/length)),
				num(z_off*i/max_n+z_A*math.sin(i*rad_z/max_n+point[p].y*rad_y_off/width+point[p].x*rad_x_off/length))
			local vec=TDS.rotate(TDS.scale({{x,y,z}},1+i*(tbl[7]-1)/max_n,1+i*(tbl[8]-1)/max_n,1+i*(tbl[9]-1)/max_n),i*tbl[4]/max_n,i*tbl[5]/max_n,i*tbl[6]/max_n,false)
			pos[i][p]={}
			pos[i][p].x,pos[i][p].y=TDS.polar_to_plane(vec)
		end
	end
	return sur,pos
end

TDS.tds.triangle_tds_final_surface=function (surface,point,rad_x,rad_y,rad_z,length,width,x_A,y_A,z_A,tbl)
	tbl=(tbl and tbl or {0,0,0,0,0,0,1,1,1})
	local rad_x_off,rad_y_off=math.ceil(length/200)*math.pi,math.ceil(width/200)*math.pi
	local sur,pos={},{}
	local angle_vis=math.rad(20) 
	local angle_theta=math.rad(20)
	local vec0={{2*math.cos(angle_theta)*math.cos(angle_vis),2*math.sin(angle_theta)*math.cos(angle_vis),2*math.sin(angle_vis)}}
	for i=1,#surface
		do
		sur[i]={}
		local shape=TDS.shape.rotate(TDS.shape.scale(TDS.shape.filter(surface[i].shape,
			function (x,y,z)
			math.randomseed(x)
			local x_off,y_off,z_off=math.random(-tbl[1],tbl[1]),math.random(-tbl[2],tbl[2]),math.random(-tbl[3],tbl[3])
			return
				num(x+x_off+x_A*math.sin(rad_x+y*rad_y_off/width)),
			num(y+y_off+y_A*math.sin(rad_y+x*rad_x_off/length)),
			num(z+z_off+z_A*math.sin(rad_z+y*rad_y_off/width+x*rad_x_off/length))
			end
			,3),tbl[7],tbl[8],tbl[9],3),tbl[4],tbl[5],tbl[6],false,3)
		local p_shape=TDS.polar_to_shape(shape)
		local x1,y1,x2,y2=_G.shape.bounding_real(p_shape)
		sur[i].x,sur[i].y=(x1+x2)/2,(y1+y2)/2
		sur[i].shape=_G.shape.translate(p_shape,-sur[i].x,-sur[i].y)
		local vec_dt=TDS.plane.normal_vector(shape)
		vec_dt=matrix_multi_number(vec_dt,(vec_dt[1][3]>0 and 1 or -1))
		local angle=math.rad(TDS.vector_angle(vec0,vec_dt))
		sur[i].alpha=_G.ass_alpha(255*math.abs(math.cos(angle)))
	end
	for i=1,#point
		do
		pos[i]={}
		math.randomseed(point[i].x)
		local x_off,y_off,z_off=math.random(-tbl[1],tbl[1]),math.random(-tbl[2],tbl[2]),math.random(-tbl[3],tbl[3])
		local x,y,z=
			num(point[i].x+x_off+x_A*math.sin(rad_x+point[i].y*rad_y_off/width)),
			num(point[i].y+y_off+y_A*math.sin(rad_y+point[i].x*rad_x_off/length)),
			num(z_off+z_A*math.sin(rad_z+point[i].y*rad_y_off/width+point[i].x*rad_x_off/length))
		local vec=TDS.rotate(TDS.scale({{x,y,z}},tbl[7],tbl[8],tbl[9]),tbl[4],tbl[5],tbl[6])
		pos[i].x,pos[i].y=TDS.polar_to_plane(vec)
	end
	return sur,pos
end

TDS.tds.surface_pos=function (sur,mode)
	local outshape={}
	local temp=(mode=="first" and sur[1] or sur[#sur])
	for i=1,#temp
		do
		outshape[#outshape+1]={}
		local s0=TDS.polar_to_shape(temp[i])
		local x1,y1,x2,y2=_G.shape.bounding_real(s0)
		local x0,y0=(x1+x2)/2,(y1+y2)/2
		outshape[#outshape]={x=x0,y=y0,shape=_G.shape.translate(s0,-x0,-y0),alpha=temp.alpha[i]}
	end
	return outshape
end

TDS.tds.sunken=function (surface,length,width,z_A,duration,ms)--table，平面凹陷
	local sur,pos={},{}
	local angle_vis=math.rad(20) 
	local angle_theta=math.rad(20)
	local vec0={{2*math.cos(angle_theta)*math.cos(angle_vis),2*math.sin(angle_theta)*math.cos(angle_vis),2*math.sin(angle_vis)}}
	local max_n=math.ceil(duration/ms)
	for i=1,max_n
		do
		sur[i]={}
		sur[i].alpha={}
		sur[i].layer={}
		sur[i].color={}
		for p=1,#surface
			do
			sur[i][p]=TDS.shape.filter(surface[p].shape,
				function (x,y,z)
				return
				x,
				y,
				num(z+z_A*i*math.exp(-math.pow(x/length,2)/2-math.pow(y/width,2)/2)/max_n)
				end
				)
			local vec_dt=TDS.plane.normal_vector(sur[i][p])
			vec_dt=matrix_multi_number(vec_dt,(vec_dt[1][3]>0 and 1 or -1))
			local angle=math.rad(TDS.vector_angle(vec0,vec_dt))
			sur[i].alpha[p]=_G.ass_alpha(255*math.abs(math.cos(angle)))
		end
	end
	return sur,pos
end

TDS.six_surface=function (ass_shape,length,width,height,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz)--table，按立方体六面排布图形
	local ass0={}
	for i=1,6
		do
		ass0[i]=(_G.type(ass_shape)=="string" and ass_shape or ass_shape[i])
	end
	local move0={{0,0,height/2},{0,width/2,0},{length/2,0,0}}
	local rotate0={{0,0,0},{90,0,0},{0,90,0}}
	local surface={}
	for i=1,6
		do
		surface[i]={shape,vector}
	end
	local n_vec={{{0,0,-1}},{{0,-1,0}},{{-1,0,0}},{{0,0,1}},{{0,1,0}},{{1,0,0}}} 
	for i=1,3
		do
		for p=1,2
			do
			surface[(p-1)*3+i]={shape=TDS.ass_shape_to_tds(ass0[(i-1)*2+p],0,math.pow(-1,p)*move0[i][1],math.pow(-1,p)*move0[i][2],math.pow(-1,p-1)*move0[i][3],rotate0[i][1],rotate0[i][2],rotate0[i][3],1,1,1,3),vector=n_vec[(p-1)*3+i]}
		end
	end
	return TDS.tds.preprocess(surface,x_off,y_off,z_off,roll,pitch,yaw,sx,sy,sz)
end

TDS.cube_surface=function(tbl,a)
	if #tbl==1
		then
		if type(tbl[i])=="string"
			then
			for i=2,6
				do
				tbl[i]=tbl[1]
			end
		else
			for i=2,6
				do
				tbl[i]=table.copy_deep(tbl[1])
			end
		end
	end
	local sur={}
	local vec={
			{{0,0,1}},
			{{0,0,-1}},
			{{0,-1,0}},
			{{0,1,0}},
			{{1,0,0}},
			{{-1,0,0}}
			}
	local theta={
			{x=0,y=0,z=0},
			{x=0,y=180,z=0},
			{x=-90,y=0,z=0},
			{x=90,y=0,z=0},
			{x=0,y=-90,z=0},
			{x=0,y=90,z=0}
			} 
	for i=1,#tbl
		do
		if type(tbl[i])=="string"
			then
			tbl[i]=TDS.ass_shape_to_tds(tbl[i],a/2,0,0,0,theta[i].x,theta[i].y,theta[i].z,1,1,1,false,3)
			sur[#sur+1]={shape=tbl[i],vector=vec[i]}
		else
			for p=1,#tbl[i]
				do
				tbl[i][p]=TDS.ass_shape_to_tds(tbl[i][p],a/2,0,0,0,theta[i].x,theta[i].y,theta[i].z,1,1,1,false,3)
				sur[#sur+1]={shape=tbl[i][p],vector=vec[i]}
			end
		end
	end
	return sur
end

TDS.dice=function(a,r,d,color1,color2)
	local color={}
	local rect=Kshape.rect(-a/2,-a/2,a,a)
	local round=shape.round(0,0,r)
	local pos={{{0,0}},{{-1,-1},{1,1}},{{-1,-1},{0,0},{1,1}},{{-1,-1},{-1,1},{1,1},{1,-1}},{{-1,-1},{-1,1},{1,1},{1,-1},{0,0}},{{-1,-1},{1,-1},{-1,0},{1,0},{-1,1},{1,1}}}
	local pa={}
	local t1={1,6,3,4,2,5}
	for i=1,#pos
		do
		local str=""
		for p=1,#pos[t1[i]]
			do
			str=str.." "..shape.round(pos[t1[i]][p][1]*d,pos[t1[i]][p][2]*d,r)
		end
		pa[i]=str
	end
	local sur=TDS.cube_surface({rect},a)
	local sur1=TDS.cube_surface(pa,a)
	for i=1,#sur1
		do
		sur[#sur+1]=table.copy_deep(sur1[i])
	end
	for i=1,#sur
		do
		color[i]=(i<=6 and color1 or color2)
	end
	return sur,color
end

TDS.fillet_dice=function(a,r,r1,d,color1,color2)
	local color={}
	local rect=shape.polygon_to_fillet(Kshape.rect(-a/2,-a/2,a,a),r1,1,1)
	local round=shape.round(0,0,r)
	local pos={{{0,0}},{{-1,-1},{1,1}},{{-1,-1},{0,0},{1,1}},{{-1,-1},{-1,1},{1,1},{1,-1}},{{-1,-1},{-1,1},{1,1},{1,-1},{0,0}},{{-1,-1},{1,-1},{-1,0},{1,0},{-1,1},{1,1}}}
	local pa={}
	local t1={1,6,3,4,2,5}
	for i=1,#pos
		do
		local str=""
		for p=1,#pos[t1[i]]
			do
			str=str.." "..shape.round(pos[t1[i]][p][1]*d,pos[t1[i]][p][2]*d,r)
		end
		pa[i]=str
	end
	local sur=TDS.cube_surface({rect},a)
	local sur1=TDS.cube_surface(pa,a)
	for i=1,#sur1
		do
		sur[#sur+1]=table.copy_deep(sur1[i])
	end
	for i=1,#sur
		do
		color[i]=(i<=6 and color1 or color2)
	end
	return sur,color
end



function table_cop(tbl,n)
	local new_tbl={}
	for i=1,n
		do
		new_tbl=_G.table.add(new_tbl,tbl)
	end
	return new_tbl
end

TDS.cube=function (length,width,height)
	local surface={}
	local rect0=format("m %d %d l %d %d l %d %d l %d %d ",-length/2,-width/2,length/2,-width/2,length/2,width/2,-length/2,width/2)
	return TDS.ass_to_tds_strech_single(rect0,height,0,0,-height/2,0,0,0,1,1,1,false)
end

TDS.double_pyramid=function (edge_n,R,height)--table，双棱锥
	local rad0=math.pi/edge_n
	local x,y=R*cos(rad0),R*sin(rad0)
	local tan1=atan(x/height) 
	local vec0={{cos(tan1),0,sin(tan1)}}
	local tri0=format("m 0 0 %d l %d %d 0 l %d %d 0",height,x,y,x,-y)
	local tri_sur={}
	for i=1,edge_n
		do
		tri_sur[#tri_sur+1]={shape=TDS.shape.rotate(tri0,0,0,(i-1)*360/edge_n,false,3),vector=TDS.rotate(vec0,0,0,(i-1)*360/edge_n)}
	end
	for i=1,edge_n
		do
		tri_sur[#tri_sur+1]={shape=TDS.shape.rotate(tri0,180,0,(i-1)*360/edge_n,false,3),vector=TDS.rotate(vec0,180,0,(i-1)*360/edge_n)}
	end
	return tri_sur
end

TDS.pyramid=function (edge_n,R,height)--table，棱锥
	local rad0=math.pi/edge_n
	local x,y=R*cos(rad0),R*sin(rad0)
	local tan1=atan(x/height)
	local vec0={{cos(tan1),0,sin(tan1)}}
	local tri0=format("m 0 0 %d l %d %d 0 l %d %d 0",height,x,y,x,-y)
	local tri_sur={}
	for i=1,edge_n
		do
		tri_sur[#tri_sur+1]={shape=TDS.shape.rotate(tri0,0,0,(i-1)*360/edge_n,false,3),vector=TDS.rotate(vec0,0,0,(i-1)*360/edge_n)}
	end
	local bottom=TDS.ass_shape_to_tds(shape.positive_edge(edge_n,0,0,R,180/edge_n),0,0,0,0,0,0,0,1,1,1,false,3)
	tri_sur[#tri_sur+1]={shape=bottom,vector={{0,0,(height>0 and -1 or 1)}}}
	return tri_sur
end

TDS.opposite_pyramid=function (edge_n,R,height)--table，对顶棱锥
	local sur1=TDS.tds.preprocess(TDS.pyramid(edge_n,R,height),0,0,-height,0,0,0,1,1,1)
	local sur2=TDS.tds.preprocess(TDS.pyramid(edge_n,R,height),0,0,height,180,0,0,1,1,1)
	return table.add(sur1,sur2)
end

TDS.double_pyramid2=function (edge_n,R,height1,height2)--table，双棱锥II型
	local sur1=TDS.pyramid(edge_n,R,height1)
	remove(sur1)
	local sur2=TDS.pyramid(edge_n,R,-height2)
	remove(sur2)
	return table.add(sur1,sur2)
end

TDS.prism=function (edge_n,R,height)--table，棱柱
	local color={}
	local rad0=math.pi/edge_n
	local x,y=R*cos(rad0),R*sin(rad0)
	local vec0={{1,0,0}}
	local rect0=format("m %d %d %d l %d %d %d l %d %d %d l %d %d %d ",x,y,-height/2,x,y,height/2,x,-y,height/2,x,-y,-height/2)
	local rect_sur={}
	for i=1,edge_n
		do
		rect_sur[#rect_sur+1]={shape=TDS.shape.rotate(rect0,0,0,(i-1)*360/edge_n,false,3),vector=TDS.rotate(vec0,0,0,(i-1)*360/edge_n)}
	end
	local bottom=TDS.ass_shape_to_tds(shape.positive_edge(edge_n,0,0,R,180/edge_n),-height/2,0,0,0,0,0,0,1,1,1,false,3)
	rect_sur[#rect_sur+1],rect_sur[#rect_sur+2]={shape=bottom,vector={{0,0,-1}}},{shape=TDS.shape.translate(bottom,0,0,height,3),vector={{0,0,1}}}
	return rect_sur
end

TDS.platform=function (edge_n,R1,R2,height)--table，棱台
	local surface={}
	local rad0=rad(180/edge_n)
	local top,t_vec=TDS.ass_shape_to_tds(shape.positive_edge(edge_n,0,0,R1,180/edge_n),height/2,0,0,0,0,0,0,1,1,1,"xyz",3),{{0,0,1}}
	local bottom,b_vec=TDS.ass_shape_to_tds(shape.positive_edge(edge_n,0,0,R2,180/edge_n),-height/2,0,0,0,0,0,0,1,1,1,"xyz",3),{{0,0,-1}}
	local x1,x2=R1*cos(rad0),R2*cos(rad0)
	local y1,y2=R1*sin(rad0),R2*sin(rad0)
	local qua0=format("m %d %d %d l %d %d %d l %d %d %d l %d %d %d ",x1,y1,height/2,x2,y2,-height/2,x2,-y2,-height/2,x1,-y1,height/2)
	local vec0=TDS.plane.normal_vector(qua0)
	vec0=matrix_multi_number(vec0,((R1>R2 and vec0[1][3]>0) or (R1<R2 and vec0[1][3]<0)) and -1 or 1)
	for i=1,edge_n
		do
		surface[#surface+1]={shape=TDS.shape.rotate(qua0,0,0,(i-1)*360/edge_n,"xyz",3),vector=TDS.rotate(vec0,0,0,(i-1)*360/edge_n,"xyz")}
	end
	surface[#surface+1],surface[#surface+2]={shape=top,vector=t_vec},{shape=bottom,vector=b_vec}
	return surface
end

TDS.opposite_platform=function (edge_n,R1,R2,height)--table，对顶棱台
	local sur1=TDS.tds.preprocess(TDS.platform(edge_n,R1,R2,height),0,0,-height/2,0,0,0,1,1,1)
	remove(sur1,#sur1-1)
	local sur2=TDS.tds.preprocess(TDS.platform(edge_n,R1,R2,height),0,0,height/2,180,0,0,1,1,1)
	remove(sur2,#sur2-1)
	return table.add(sur1,sur2)
end

TDS.double_platform=function (edge_n,R1,R2,height)--table，双棱台
	local sur1=TDS.tds.preprocess(TDS.platform(edge_n,R1,R2,height),0,0,height/2,0,0,0,1,1,1)
	remove(sur1,#sur1)
	local sur2=TDS.tds.preprocess(TDS.platform(edge_n,R1,R2,height),0,0,-height/2,0,180,0,1,1,1)
	remove(sur2,#sur2)
	return table.add(sur1,sur2)
end

TDS.double_platform2=function (edge_n,R1,R2,R3,height1,height2)--table，双棱台II型
local sur1=TDS.tds.preprocess(TDS.platform(edge_n,R1,R2,height1),0,0,height1/2,0,0,0,1,1,1,false)
	remove(sur1,#sur1)
	local sur2=TDS.tds.preprocess(TDS.platform(edge_n,R3,R2,height2),0,0,-height2/2,0,180,0,1,1,1,false)
	remove(sur2,#sur2)
	return table.add(sur1,sur2)
end

TDS.icosahedron=function (a)--table，正二十面体
	local surface={}
	local rad0=rad(36)
	local R=0.5*a/sin(rad0)
	local x1,y1=R*cos(rad0),a/2
	local h1=sqrt(pow(a,2)*3/4-pow(x1,2))
	local h2=sqrt(pow(a,2)*3/4-pow(R*(1-cos(rad0)),2))
	local tri1=format("m %d %d %d l %d %d %d l %d %d %d ",0,0,h1,x1,y1,0,x1,-y1,0)
	local tri2=format("m %d %d %d l %d %d %d l %d %d %d ",x1,y1,0,x1,-y1,0,R,0,-h2)
	local vec1=TDS.plane.normal_vector(tri1)
	local vec1=matrix_multi_number(vec1,vec1[1][3]>0 and 1 or -1)
	local vec2=TDS.plane.normal_vector(tri2)
	local vec2=matrix_multi_number(vec2,vec2[1][3]>0 and 1 or -1)
	for i=1,5 do
		surface[i]={shape=TDS.shape.rotate(tri1,0,0,(i-1)*360/5,false,3),vector=TDS.rotate(vec1,0,0,(i-1)*360/5)}
	end
	for i=1,5
		do
		surface[#surface+1]={shape=TDS.shape.rotate(tri2,0,0,(i-1)*360/5,false,3),vector=TDS.rotate(vec2,0,0,(i-1)*360/5)}
	end
	local sur1,sur2=TDS.tds.preprocess(surface,0,0,h2/2,0,0,0,1,1,1),TDS.tds.preprocess(surface,0,0,-h2/2,180,0,36,1,1,1)
	return table.add(sur1,sur2)
end

TDS.dodecahedron=function (R)--table，正十二面体
	local surface={}
	local rad0=rad(36)
	local rad1=rad(54)
	local a=4*R/(sqrt(3)+sqrt(15))
	local r=a*sin(rad1)/sin(rad0)
	local h=a*sqrt(2.5+sqrt(5)*11/10)/2
	local f0=TDS.ass_shape_to_tds(shape.positive_edge(5,0,0,r,0),0,-r*cos(rad0),0,0,0,0,180,1,1,1,false,3)
	local vec0={{0,0,1}}
	local f1=TDS.shape.translate(TDS.shape.rotate_org(f0,deg(acos(-1/sqrt(5))),{{0,1,0}},3),r*cos(rad0),0,0,3)
	local vec1=TDS.plane.normal_vector(f1)
	local vec1=matrix_multi_number(vec1,vec1[1][3]>0 and 1 or -1)
	for i=1,5
		do
		surface[#surface+1]={shape=TDS.shape.rotate(f1,0,0,(i-1)*360/5,false,3),vector=TDS.rotate(vec1,0,0,(i-1)*360/5)}
	end
	surface[#surface+1]={shape=TDS.shape.translate(f0,r*cos(rad0),0,0,3),vector=vec0}
	surface=TDS.tds.preprocess(surface,0,0,1.614*h,0,0,0,1,1,1,false)
	surface=table.add(surface,TDS.tds.preprocess(surface,0,0,0,0,180,0,1,1,1,false))
	return surface
end


TDS.diamond_easy=function (R1,R2,h1,h2,edge_n)--table，简易钻石
	local surface={}
	local top=TDS.ass_shape_to_tds(shape.positive_edge(edge_n,0,0,R1,0),h1,0,0,0,0,0,0,1,1,1,false,3)--钻石顶部
	local t_vec={{0,0,1}}--顶部向量
	local x1,y1=R2*cos(rad(180/edge_n)),R2*sin(rad(180/edge_n))
	local tri1=format("m %d %d %d l %d %d %d l %d %d %d ",x1,y1,0,x1,-y1,0,R1,0,h1)--三角形（1型）
	local tan1=atan((x1-R1)/h1)
	local vec1={{cos(tan1),0,sin(tan1)}}--三角形方向向量（1型）
	local x2,y2=R1*cos(rad(180/edge_n)),R1*sin(rad(180/edge_n))
	local tri2=TDS.shape.rotate(format("m %d %d %d l %d %d %d l %d %d %d ",x2,y2,h1,x2,-y2,h1,R2,0,0),0,0,180/edge_n,false,3)--三角形（2型）
	local tan2=atan((R2-x2)/h1)
	local vec2=TDS.rotate({{cos(tan2),0,sin(tan2)}},0,0,180/edge_n)--三角形方向向量（2型）
	local tri3=format("m %d %d %d l %d %d %d l %d %d %d ",x1,y1,0,x1,-y1,0,0,0,-h2)--三角形（3型）
	local tan3=atan(-x1/h2)
	local vec3={{cos(tan3),0,sin(tan3)}}--三角形方向向量（3型）
	for p=1,3
		do
		for i=1,edge_n
			do
			surface[#surface+1]={shape,vector}
			local tri=(p==1 and tri1 or (p==2) and tri2 or tri3)
			local vec=(p==1 and vec1 or (p==2) and vec2 or vec3)
			surface[#surface].shape=TDS.shape.rotate(tri,0,0,(i-1)*360/edge_n,false,3)
			surface[#surface].vector=TDS.rotate(vec,0,0,(i-1)*360/edge_n)
		end
	end
	surface[#surface+1]={shape=top,vector=t_vec}
	return surface
end

TDS.crystal=function(edge_n,r,h1,h2)
	local surface={}
	local a1=2*r*math.sin(math.rad(180/edge_n))
	local a2=r*math.cos(math.rad(180/edge_n))
	local r1=string.format("m %d %d %d l %d %d %d l %d %d %d l %d %d %d ",-a1/2,a2,h1/2,a1/2,a2,h1/2,a1/2,a2,-h1/2,-a1/2,a2,-h1/2)
	local vec1={{0,1,0}}
	local r2=string.format("m %d %d %d l %d %d %d l %d %d %d ",-a1/2,a2,h1/2,a1/2,a2,h1/2,0,0,h2+h1/2)
	local vec2=TDS.plane.normal_vector(r2)
	vec2=(vec2[1][3]<0 and matrix_multi_number(vec2,-1) or vec2)
	local r3=TDS.shape.rotate(r2,0,180,0,false,3)
	local vec3=TDS.rotate(vec2,0,180,0)
	for i=1,edge_n
		do
		surface[#surface+1]={shape=TDS.shape.rotate(r1,0,0,(i-1)*360/edge_n,false,3),vector=TDS.rotate(vec1,0,0,(i-1)*360/edge_n)}
		surface[#surface+1]={shape=TDS.shape.rotate(r2,0,0,(i-1)*360/edge_n,false,3),vector=TDS.rotate(vec2,0,0,(i-1)*360/edge_n)}
		surface[#surface+1]={shape=TDS.shape.rotate(r3,0,0,(i-1)*360/edge_n,false,3),vector=TDS.rotate(vec3,0,0,(i-1)*360/edge_n)}
	end
	return surface
end

TDS.to_platform=function(ass_shape,sx,sy,h)
	local surface={}
end

TDS.ball=function (R,p_l,p_w,pct_w,pct_h,filler)--table，球面百分比填充
	p_l,p_w=p_l and p_l or 10,p_w and p_w or 10
	pct_w,pct_h=pct_w and pct_w or 2000/R,pct_h and pct_h or 2000/R
	local mod=TDS.ass_or_tds(filler)
	if (not mod)
		then
		filler=format("m %d %d %d l %d %d %d l %d %d %d l %d %d %d ",-p_l/2,-p_w/2,R,p_l/2,-p_w/2,R,p_l/2,p_w/2,R,-p_l/2,p_w/2,R)
	elseif (mod==2)
		then
		filler=TDS.ass_shape_to_tds(filler,R,0,0,0,0,0,0,1,1,1,false,3)
	end
	local surface={}
	local rect0=filler
	local vec0={{0,0,1}}
	local max_n1=ceil(math.pi*R*pct_h*0.01/p_l)
	for i=1,max_n1
		do
		local z_rad=i*180/max_n1
		local R2=R*sin(rad(z_rad))
		local max_n2=ceil(2*math.pi*R2*pct_w*0.01/p_w)
		for p=1,max_n2
			do
			surface[#surface+1]={shape,vector}
			surface[#surface].shape=TDS.shape.rotate(rect0,z_rad,0,(p-1)*360/max_n2,false,3)
			surface[#surface].vector=TDS.rotate(vec0,z_rad,0,(p-1)*360/max_n2)
		end
	end
	surface[#surface+1]={shape=rect0,vector=vec0}
	return surface
end

TDS.cone_multi=function (R1,R2,h,edge_n)
	local sur={} 
	local rad0=math.rad(360/edge_n)
	local tri1=string.format("m %d %d %d l %d %d %d l %d %d %d",0,0,h,R1,0,0,R2*math.cos(rad0/2),R2*math.sin(rad0/2),0)
	local vec=TDS.plane.normal_vector(tri1)
	local vec1=matrix_multi_number(vec,(vec[1][3]>0 and 1 or -1))
	local tri2=string.format("m %d %d %d l %d %d %d l %d %d %d",0,0,h,R1,0,0,R2*math.cos(-rad0/2),R2*math.sin(-rad0/2),0)
	local vec_2=TDS.plane.normal_vector(tri2)
	local vec2=matrix_multi_number(vec_2,(vec_2[1][3]>0 and 1 or -1))
	for i=1,2
		do
		local shape0=(i==1 and tri1 or tri2)
		local vector0=(i==1 and vec1 or vec2)
		for p=1,edge_n
			do
			sur[#sur+1]={shape=TDS.shape.rotate(shape0,0,0,(p-1)*360/edge_n,3),vector=TDS.rotate(vector0,0,0,(p-1)*360/edge_n)}
		end
	end
	local sur2=TDS.tds.preprocess(sur,0,0,0,180,0,0,1,1,1,3)
	return _G.table.add(sur,sur2)
end

TDS.clock=function (R,h,edge_n,time,h_l,m_l,s_l,h_w,m_w,s_w)
	local sur1={}
	local dur=_G.Yutils.ass.convert_time(time)--转换为毫秒格式
	local second=dur/1000--计算秒数
	local minute=second/60--计算分数
	local hour=minute/60--计算时数
	local s_theta=second*6--计算秒针旋转角度
	local m_theta=minute*6--计算分针旋转角度
	local h_theta=hour*360/12--计算时针旋转角度
	--local sur1=TDS.prism(edge_n,R,h)
	local h_hand=string.format("m 0 0 0 l %d %d 0 l %d 0 0 l %d %d 0 ",h_l/2,h_w/2,h_l,h_l/2,-h_w/2)
	local m_hand=string.format("m 0 0 0 l %d %d 0 l %d 0 0 l %d %d 0 ",m_l/2,m_w/2,m_l,m_l/2,-m_w/2)
	local s_hand=string.format("m 0 0 0 l %d %d 0 l %d 0 0 l %d %d 0 ",s_l/2,s_w/2,s_l,s_l/2,-s_w/2)
	local vec={{0,0,1}}
	for i=1,3
		do
		sur1[#sur1+1]={shape=(i==1 and h_hand or (i==2) and m_hand or s_hand),vector=vec}
	end
	return sur1,_G.Yutils.ass.convert_time(time),s_theta,m_theta,h_theta
end

function table.replace(tbl,str)
	local tbl1=table.copy_deep(tbl)
	for i=1,#tbl1
		do
		tbl1[i]=str
	end
	return tbl1
end

TDS.rubik_R=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][2])>=0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if y0>=(layer-1)*a/2
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,0,theta,0,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,0,theta,0)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_U=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][3])>=0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if z0>=(layer-1)*a/2
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,0,0,theta,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,0,0,theta)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_F=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][1])>=0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if x0>=(layer-1)*a/2
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,theta,0,0,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,theta,0,0)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_L=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][2])<=0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if y0<=-a/2
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,0,theta,0,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,0,theta,0)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_D=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][3])<=0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if z0<=-(layer-1)*a/2 and z0>=-layer*a/2
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,0,0,theta,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,0,0,theta)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_B=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][1])<=0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if x0<=-(layer-1)*a/2 and x0>=-layer*a/2
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,theta,0,0,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,theta,0,0)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_M=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][2])==0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if y0>=-(layer-2)*a/2 and y0<=(layer-2)*a/2
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,0,theta,0,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,0,theta,0)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_E=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][3])<=0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if z0>=-(layer-2)*a/2 and z0<=(layer-2)*a/2
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,0,0,theta,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,0,0,theta)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_S=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][1])<=0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if x0>=-(layer-2)*a/2 and x0<=(layer-2)*a/2
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,theta,0,0,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,theta,0,0)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_r=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][2])>=0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if y0>=0
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,0,theta,0,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,0,theta,0)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_u=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][3])>=0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if z0>=0
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,0,0,theta,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,0,0,theta)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_f=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][1])>=0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if x0>=0
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,theta,0,0,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,theta,0,0)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_l=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][2])<=0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if y0<=a/2
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,0,theta,0,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,0,theta,0)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_d=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][3])<=0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if z0<=0
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,0,0,theta,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,0,0,theta)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_b=function (sur,theta,layer,a)
	local surface=table.copy_deep(sur)
	local number={}
	for i=1,#surface
		do
		if num(surface[i].vector[1][1])<=0
			then
			local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(surface[i].shape)
			local x0,y0,z0=num((x1+x2)/2),num((y1+y2)/2),num((z1+z2)/2)
			if x0<=0
				then
				surface[i].shape=TDS.shape.rotate(surface[i].shape,theta,0,0,false,3)
				surface[i].vector=TDS.rotate(surface[i].vector,theta,0,0)
				number[#number+1]=i
			end
		end
	end
	return surface
end

TDS.rubik_algorithm_single=function (surface,str,layer,a)--单步公式建模
	local sur=table.copy_deep(surface)
	theta={x=0,y=0,z=0}
	if str=="R" or str=="R'" or str=="R2" or str=="R'2"
		then
		theta.y=(str=="R" and 90 or (str=="R'") and -90 or (str=="R'2") and -180 or 180)
		return TDS.rubik_R(sur,theta.y,layer,a)
	elseif str=="U" or str=="U'" or str=="U2" or str=="U'2"
		then
		theta.z=(str=="U" and 90 or (str=="U'") and -90 or (str=="U'2") and -180 or 180)
		return TDS.rubik_U(sur,theta.z,layer,a)
	elseif str=="F" or str=="F'" or str=="F2" or str=="F'2"
		then
		theta.x=(str=="F" and 90 or (str=="F'") and -90 or (str=="F'2") and -180 or 180)
		return TDS.rubik_F(sur,theta.x,layer,a)
	elseif str=="L" or str=="L'" or str=="L2" or str=="L'2"
		then
		theta.y=(str=="L" and -90 or (str=="L'") and 90 or (str=="L2") and -180 or 180)
		return TDS.rubik_L(sur,theta.y,layer,a)
	elseif str=="D" or str=="D'" or str=="D2" or str=="D'2"
		then
		theta.z=(str=="D" and -90 or (str=="D'") and 90 or (str=="D2") and -180 or 180)
		return TDS.rubik_D(sur,theta.z,layer,a)
	elseif str=="B" or str=="B'" or str=="B2" or str=="B'2"
		then
		theta.x=(str=="B" and -90 or (str=="B'") and 90 or (str=="B2") and -180 or 180)
		return TDS.rubik_B(sur,theta.x,layer,a)
	elseif str=="M" or str=="M'" or str=="M2" or str=="M'2"
		then
		theta.y=(str=="M" and -90 or (str=="M'") and 90 or (str=="M2") and -180 or 180)
		return TDS.rubik_M(sur,theta.y,layer,a)
	elseif str=="E" or str=="E'" or str=="E2" or str=="E'2"
		then
		theta.z=(str=="E" and -90 or (str=="E'") and 90 or (str=="E2") and -180 or 180)
		return TDS.rubik_E(sur,theta.z,layer,a)
	elseif str=="S" or str=="S'" or str=="S2" or str=="S'2"
		then
		theta.x=(str=="S" and -90 or (str=="S'") and 90 or (str=="S2") and -180 or 180)
		return TDS.rubik_S(sur,theta.x,layer,a)
	elseif str=="r" or str=="r'" or str=="r2" or str=="r'2"
		then
		theta.y=(str=="r" and 90 or (str=="r'") and -90 or (str=="r'2") and -180 or 180)
		return TDS.rubik_r(sur,theta.y,layer,a)
	elseif str=="u" or str=="u'" or str=="u2" or str=="u'2"
		then
		theta.z=(str=="u" and 90 or (str=="u'") and -90 or (str=="u'2") and -180 or 180)
		return TDS.rubik_u(sur,theta.z,layer,a)
	elseif str=="f" or str=="f'" or str=="f2" or str=="f'2"
		then
		theta.x=(str=="f" and 90 or (str=="f'") and -90 or (str=="f'2") and -180 or 180)
		return TDS.rubik_f(sur,theta.x,layer,a)
	elseif str=="l" or str=="l'" or str=="l2" or str=="l'2"
		then
		theta.y=(str=="l" and -90 or (str=="l'") and 90 or (str=="l2") and -180 or 180)
		return TDS.rubik_l(sur,theta.y,layer,a)
	elseif str=="d" or str=="d'" or str=="d2" or str=="d'2"
		then
		theta.z=(str=="d" and -90 or (str=="d'") and 90 or (str=="d2") and -180 or 180)
		return TDS.rubik_d(sur,theta.z,layer,a)
	elseif str=="b" or str=="b'" or str=="b2" or str=="b'2"
		then
		theta.x=(str=="b" and -90 or (str=="b'") and 90 or (str=="b2") and -180 or 180)
		return TDS.rubik_b(sur,theta.x,layer,a)
	elseif str=="x" or str=="x'" or str=="x2" or str=="x'2"
		then
		theta.y=(str=="x" and 90 or (str=="x'") and -90 or (str=="x'2") and -180 or 180)
		return TDS.tds.preprocess(sur,0,0,0,0,theta.y,0,1,1,1,false,3)
	elseif str=="y" or str=="y'" or str=="y2" or str=="y'2"
		then
		theta.z=(str=="y" and 90 or (str=="y'") and -90 or (str=="y'2") and -180 or 180)
		return TDS.tds.preprocess(sur,0,0,0,0,0,theta.z,1,1,1,false,3)
	elseif str=="z" or str=="z'" or str=="z2" or str=="z'2"
		then
		theta.x=(str=="z" and 90 or (str=="z'") and -90 or (str=="z'2") and -180 or 180)
		return TDS.tds.preprocess(sur,0,0,0,theta.x,0,0,1,1,1,false,3)
	elseif str=="" or (not str)
		then
		theta.x=0
		return sur
	else
		error("only support correct algorithm")
	end
end

TDS.rubik_algorithm=function (surface,str,layer,a)
	local sur=table.copy_deep(surface)
	local tbl={}
	str=string.gsub(string.gsub(str," ",""),"’","'")
	for s in string.gmatch(str,"%a'?%d?")
		do
		tbl[#tbl+1]=s
	end
	for i=1,#tbl
		do
		sur=TDS.rubik_algorithm_single(sur,tbl[i],layer,a)
	end
	return sur
end


TDS.rubik=function(layer,a)--n阶魔方建模
	assert((type(layer)=="number"),"layer has to be a number value")
	assert(layer>=1,"layer has to be a bigger than 0")
	b=0
	local c_set={"&HFFFFFF&","&HFF0000&","&H2BF7FF&","&H28FF12&","&H0000FF&","&H58BAFF&"}
	local sur={}
	local sur_t={}
	local color={}
	local rect0=string.format("m %d %d %d l %d %d %d l %d %d %d l %d %d %d ",-a/2+b,-a/2+b,a*layer/2,-a/2+b,a/2-b,a*layer/2,a/2-b,a/2-b,a*layer/2,a/2-b,-a/2+b,layer*a/2)
	for i=1,layer--顶面建模
		do
		for p=1,layer
			do
			sur[#sur+1]={shape=TDS.shape.translate(rect0,-(layer-1)*a/2+(i-1)*a,-(layer-1)*a/2+(p-1)*a,0,3),vector={{0,0,1}}}
			color[#color+1]="&HFFFFFF&"
		end
	end
	for i=1,4
		do
		sur_t[#sur_t+1]=TDS.tds.preprocess(sur,0,0,0,0,(i-1)*90,0,1,1,1,false)
		for p=1,layer^2
			do
			color[(i-1)*(layer^2)+p]=c_set[i]
		end
	end
	for i=1,2
		do
		sur_t[#sur_t+1]=TDS.tds.preprocess(sur,0,0,0,(i==1 and 90 or -90),0,0,1,1,1,false)
		for p=1,layer^2
			do
			color[#color+1]=c_set[i+4]
		end
	end

	local function intergrate(tbl)
		local new_tbl={}
		for i=1,#tbl
			do
			new_tbl=table.add(new_tbl,table.copy_deep(tbl[i]))
		end
		return new_tbl
	end

	return intergrate(sur_t),color
end


TDS.rubik_algorithm_dynamic_judge=function(polar_shape,str,layer,a)
	local s=polar_shape
	if str=="R" or str=="R'" or str=="R2" or str=="R'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local y0=num((y1+y2)/2)
		if y0>=(layer-1)*a/2
			then
			return true
		else
			return false
		end
	elseif str=="U" or str=="U'" or str=="U2" or str=="U'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local z0=num((z1+z2)/2)
		if z0>=(layer-1)*a/2
			then
			return true
		else
			return false
		end
	elseif str=="F" or str=="F'" or str=="F2" or str=="F'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local x0=num((x1+x2)/2)
		if x0>=(layer-1)*a/2
			then
			return true
		else
			return false
		end
	elseif str=="L" or str=="L'" or str=="L2" or str=="L'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local y0=(y1+y2)/2
		if y0<=-a/2
			then
			return true
		else
			return false
		end
	elseif str=="D" or str=="D'" or str=="D2" or str=="D'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local z0=(z1+z2)/2
		if z0<=-(layer-1)*a/2 and z0>=-layer*a/2
			then
			return true
		else
			return false
		end
	elseif str=="B" or str=="B'" or str=="B2" or str=="B'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local x0=(x1+x2)/2
		if x0<=-(layer-1)*a/2 and x0>=-layer*a/2
			then
			return true
		else
			return false
		end
	elseif str=="M" or str=="M'" or str=="M2" or str=="M'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local y0=(y1+y2)/2
		if y0>=-(layer-2)*a/2 and y0<=(layer-2)*a/2
			then
			return true
		else
			return false
		end
	elseif str=="E" or str=="E'" or str=="E2" or str=="E'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local z0=(z1+z2)/2
		if z0>=-(layer-2)*a/2 and z0<=(layer-2)*a/2
			then
			return true
		else
			return false
		end
	elseif str=="S" or str=="S'" or str=="S2" or str=="S'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local x0=(x1+x2)/2
		if x0>=-(layer-2)*a/2 and x0<=(layer-2)*a/2
			then
			return true
		else
			return false
		end
	elseif str=="r" or str=="r'" or str=="r2" or str=="r'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local y0=num((y1+y2)/2)
		if y0>=0
			then
			return true
		else
			return false
		end
	elseif str=="u" or str=="u'" or str=="u2" or str=="u'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local z0=num((z1+z2)/2)
		if z0>=0
			then
			return true
		else
			return false
		end
	elseif str=="f" or str=="f'" or str=="f2" or str=="f'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local x0=num((x1+x2)/2)
		if x0>=0
			then
			return true
		else
			return false
		end
	elseif str=="l" or str=="l'" or str=="l2" or str=="l'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local y0=(y1+y2)/2
		if y0<=0
			then
			return true
		else
			return false
		end
	elseif str=="d" or str=="d'" or str=="d2" or str=="d'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local z0=(z1+z2)/2
		if z0<=0
			then
			return true
		else
			return false
		end
	elseif str=="b" or str=="b'" or str=="b2" or str=="b'2"
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local x0=(x1+x2)/2
		if x0<=0
			then
			return true
		else
			return false
		end
	elseif str=="" or (not str)
		then
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
		local y0=(y1+y2)/2
		if y0>=(layer-1)*a/2 and y0<=layer*a/2
			then
			return true
		else
			return false
		end
	else
		return true
	end
end

function isinclude(tbl,value)
	local k=0
	for i=1,#tbl
		do
		if value==tbl[i]
			then
			k=k+1
		end
	end
	return k>0
end

TDS.rubik_dynamic_single=function(surface,str,step_dur,ms,layer,a,color,vec_light,light_str,nature_light)
	local len=#surface
	local light_str=(light_str and light_str or 1)
	local nature_light=(nature_light and nature_light or 0.01)
	local angle_vis=rad(18.6) 
	local angle_theta=rad(19.6)
	local vec0={{2*cos(angle_theta)*cos(angle_vis),2*sin(angle_theta)*cos(angle_vis),2*sin(angle_vis)}}
	local sur=table.copy_deep(surface)
	local sur1=table.copy_deep(surface)
	step_dur=(string.match(str,"2") and 2*step_dur or step_dur)
	local max_n=math.ceil(step_dur/ms)
	local new_sur={}
	local sur_temp=TDS.rubik_algorithm_single(sur1,str,layer,a)
	local theta0=table.copy_deep(theta)
	local vec_light=(vec_light and vec_light or {{-vec0[1][1],-vec0[1][2],-vec0[1][3]}})
	for i=1,max_n
		do
		new_sur[i]={}
		for p=1,#sur
			do
			if TDS.rubik_algorithm_dynamic_judge(sur[p].shape,str,layer,a)
				then
				rx,ry,rz=theta0.x,theta0.y,theta0.z
				lay=0
			else
				rx,ry,rz=0,0,0
				lay=3
			end
			local angle=TDS.vector_angle(vec0,TDS.rotate(sur[p].vector,(i-1)*rx/(max_n-1),(i-1)*ry/(max_n-1),(i-1)*rz/(max_n-1)))
			if angle<=90
				then
				new_sur[i][#new_sur[i]+1]={shape,color,layer}
				local s=TDS.shape.rotate(sur[p].shape,(i-1)*rx/(max_n-1),(i-1)*ry/(max_n-1),(i-1)*rz/(max_n-1),false,3)
				local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
				local x0,y0,z0=(x1+x2)/2,(y1+y2)/2,(z1+z2)/2
				local r=math.distance(1.5*a,1.5*a)
				local rad1=rad(TDS.vector_angle(TDS.rotate(sur[p].vector,(i-1)*rx/(max_n-1),(i-1)*ry/(max_n-1),(i-1)*rz/(max_n-1)),vec_light))
				new_sur[i][#new_sur[i]].shape=s
				new_sur[i][#new_sur[i]].color=interpolate_color_light(color[p],100,100,100*(light_str*abs(cos(rad1),0)+nature_light))
				local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(s)
				local x0,y0,z0=(x1+x2)/2,(y1+y2)/2,(z1+z2)/2
				local lx,ly,lz=len*vec0[1][1],3*len*vec0[1][2],3*len*vec0[1][3]
				local max_r=math.distance(layer*a/2,layer*a/2)
				new_sur[i][#new_sur[i]].layer=num(2*len*math.cos(math.rad(angle))+(4*(x0+max_r)*len/(max_r))+(2*(y0+max_r)*len/(max_r))+(3*(z0+max_r)*len/(max_r)))
				new_sur[i][#new_sur[i]].layer=lay

			end
		end
	end
	return new_sur,step_dur
end

TDS.rubik_dynamic=function(algorithm,step_dur,ms,layer,a,vec_light,light_str,nature_light)
	local light_str=(light_str and light_str or 1)
	local nature_light=(nature_light and nature_light or 0.01)
	local angle_vis=rad(18.6) 
	local angle_theta=rad(19.6)
	local vec0={{2*cos(angle_theta)*cos(angle_vis),2*sin(angle_theta)*cos(angle_vis),2*sin(angle_vis)}}
	local vec_light=(vec_light and vec_light or {{-vec0[1][1],-vec0[1][2],-vec0[1][3]}})
	local sur_set,color=TDS.rubik(layer,a)--建模
	local tbl={}
	local new_sur={}
	local sur=table.copy_deep(sur_set)
	local dur=0
	algorithm=string.gsub(string.gsub(algorithm," ",""),"’","'")--公式标准化
	for s in string.gmatch(algorithm,"%a'?%d?")
		do
		tbl[#tbl+1]=s
	end
	for i=1,#tbl
		do
		local sur_temp,sdur=TDS.rubik_dynamic_single(sur,tbl[i],step_dur,ms,layer,a,color,vec_light,light_str,nature_light)
		new_sur=table.add(new_sur,sur_temp)
		sur=TDS.rubik_algorithm_single(sur,tbl[i],layer,a)
		dur=dur+sdur
	end
	return new_sur,dur
end

TDS.rubik_algorithm_reverse=function(algorithm)--公式逆序
	local function single(str)
		if string.match(str,"'")
			then
			return string.gsub(str,"'","")
		elseif string.match(str,"%d")
			then
			return str
		else
			return str.."'"
		end
	end
	local al=algorithm
	al=string.gsub(string.gsub(al," ",""),"‘","'")
	local new_al=""
	local tbl={}
	for s in string.gmatch(al,"%a'?%d?")
		do
		tbl[#tbl+1]=single(s)
	end
	for i=#tbl,1,-1
		do
		new_al=new_al..tbl[i]
	end
	return new_al
end

TDS.rubik_algorithm_split=function(algorithm)--公式拆分
	assert(type(algorithm)=="string","error,split")
	local al0=algorithm
	al0=string.gsub(string.gsub(al0," ",""),"’","'")
	local new_al=""
	local tbl={}
	for s in string.gmatch(al0,"%a'?%d?")
		do
		tbl[#tbl+1]=s
	end
	return tbl
end

TDS.rubik_algorithm_intergrate=function(algorithm)
	local new_tbl={}
	local str_tbl={}
	local tbl=TDS.rubik_algorithm_split(algorithm)
	new_tbl[1]={tbl[1]}
	for i=2,#tbl
		do
		if string.match(tbl[i],"[A-Z]")==string.match(tbl[i-1],"[A-Z]")
			then
			new_tbl[#new_tbl][#new_tbl[#new_tbl]+1]=tbl[i]
		else
			new_tbl[#new_tbl+1]={tbl[i]}
		end
	end
	for i=1,#new_tbl
		do
		local tag=string.match(new_tbl[i][1],"[A-Z]")
		str_tbl[#str_tbl+1]=""
		local k=0
		for p=1,#new_tbl[i]
			do
			if string.match(new_tbl[i][p],"2")
				then
				k=k+2
			elseif string.match(new_tbl[i][p],"'") and (not(string.match(new_tbl[i][p],"2")))
				then
				k=k-1
			elseif string.len(new_tbl[i][p])==1
				then
				k=k+1
			end
		end
		if k>=4
			then
			repeat
			k=k-4
			until k<4
		end
		if k==0
			then
			str_tbl[#str_tbl]=""
		elseif k==1
			then
			str_tbl[#str_tbl]=tag
		elseif k==2
			then
			str_tbl[#str_tbl]=tag.."2"
		elseif (k==3 or k==-1)
			then
			str_tbl[#str_tbl]=tag.."'"
		end
	end
	return concat(str_tbl)
end

TDS.rubik_algorithm_setup=function(algorithm,length)
	length=(length and length or 1)
	local al_tbl=TDS.rubik_algorithm_split(algorithm)
	for i=1,length
		do
		al_tbl[#al_tbl+1]=TDS.rubik_algorithm_reverse(al_tbl[i])
	end
	return concat(al_tbl)
end

local surface_num={U=1,B=2,D=3,F=4,R=5,L=6}
local n_vec={
			R={{0,1,0}},
			U={{0,0,1}},
			F={{1,0,0}},
			L={{0,-1,0}},
			D={{0,0,-1}},
			B={{-1,0,0}}
			}

TDS.rubik_solve_cross=function(surface)
	local sur=table.copy_deep(surface)
	layer=3
	a=90
	surface=table.copy_deep(surface)
	local FD={35,20,vector={{1,0,0}}}
	local RD={42,24,vector={{0,1,0}}}
	local BD={11,26,vector={{-1,0,0}}}
	local LD={49,22,vector={{0,-1,0}}}
	local tbl={FD,RD,BD,LD}
	local state_tbl={"F","R","B","L"}
	local new_tbl={}
	local function dir(surface,tbl)--判断底色朝向
		local vec1=table.copy_deep(surface[tbl[1]].vector)--确定当前该面的朝向
		local vec2=table.copy_deep(surface[tbl[2]].vector)
		local state=""
		for k,v in pairs(n_vec)
			do
			local angle=TDS.vector_angle(vec2,v)
			if num(angle)==0
				then
				state=state..k
			end
		end
		for k,v in pairs(n_vec)
			do
			local angle=TDS.vector_angle(vec1,v)
			if num(angle)==0
				then
				state=state..k
			end
		end
		return state
	end

	local function state_table(surface)
		local new_tbl={}
		for i=1,#tbl
			do
			new_tbl[i]=dir(surface,tbl[i])--记录四个块的目前朝向
		end
		return new_tbl
	end

	local new_tbl=state_table(surface)--计算初始底层棱块状态

	local al_end=""--初始化公式

	local function top_layer_case(algorithm,len)--顶层预置多种方案
		local function mirror(str)
			local stbl={R="L",L="R",F="B",B="F",U="D",D="U"}
			local tag=string.match(str,"[A-Z]")
			return TDS.rubik_algorithm_reverse(string.gsub(str,tag,stbl[tag]))
		end
		local al_tbl=TDS.rubik_algorithm_split(algorithm)
		local al_tbl1=TDS.rubik_algorithm_split(algorithm)
		al_tbl[1],al_tbl[#al_tbl]=TDS.rubik_algorithm_reverse(al_tbl[1]),mirror(al_tbl[#al_tbl])
		local setup=TDS.rubik_algorithm_setup
		local plan={setup(concat(al_tbl1),len),setup(concat(al_tbl),len),setup(concat(al_tbl1,"U"),len),setup(concat(al_tbl1,"U2"),len),setup(concat(al_tbl1,"U'"),len)}
		return plan
	end

	function cross_single_step(s_tbl,i,layer,a)--整体状态表,第i个元素
		local out_al=""
		local state1=s_tbl[i]
		local s11,s12=string.sub(state1,1,1),string.sub(state1,2,2)
		if s11~="U" and s11~="D"--十字棱色相错误
			then
			if s12~="U" and s12~="D"--块位于侧面(RLFB)
				then
				if string.match(s11,"[FB]")
					then
					out_al=out_al..((string.match(s11,"[F]") and string.match(s12,"[R]")) or ((string.match(s11,"[B]") and string.match(s12,"[L]"))) and s12 or TDS.rubik_algorithm_reverse(s12))
				elseif string.match(s11,"[RL]")
					then
					out_al=out_al..((string.match(s11,"[L]") and string.match(s12,"[F]")) or ((string.match(s11,"[R]") and string.match(s12,"[B]"))) and s12 or TDS.rubik_algorithm_reverse(s12))
				end
			elseif (s12=="U" or s12=="D")
				then
				str=(s12=="U" and "" or "'")
				out_al=out_al..s11..str
				if s11=="F"
					then
					out_al=out_al.."R"
				elseif s11=="B"
					then
					out_al=out_al.."L"
				elseif s11=="R"
					then
					out_al=out_al.."B"
				elseif s11=="L"
					then
					out_al=out_al.."F"
				end
			end
		elseif s11=="D"--十字棱色相正确且位于底层
			then
			out_al=out_al..(s12.."2")
		end
		return ((s12=="U") and top_layer_case(out_al,1) or (s12=="D") and top_layer_case(out_al,1) or out_al)
	end

	local function top_layer_check(surface,stop,tbl,s_tbl,mode)
		local al_temp=cross_single_step(s_tbl,stop+1)--原始公式表
		al_temp=(type(al_temp)=="table" and al_temp[1] or al_temp)
		al_temp=TDS.rubik_algorithm_split(al_temp)
		local al_1=al_temp[1]
		local al_2=al_temp[#al_temp]
		local k=0
		for i=1,stop
			do
			local dir_tbl=dir(surface,tbl[i])
			local sta_tbl=TDS.rubik_algorithm_split(dir_tbl)--状态表
			local sta_1,sta_2=sta_tbl[1],sta_tbl[#sta_tbl]
			local tag1=string.match(al_2,"[A-Z]")
			local tag2=string.match(sta_2,"[A-Z]")
			if tag1==tag2
				then
				k=k+1
			end
		end
		if mode
			then
				for i=1,stop
				do
				local dir_tbl=dir(surface,tbl[i])
				local sta_tbl=TDS.rubik_algorithm_split(dir_tbl)--状态表
				local sta_1,sta_2=sta_tbl[1],sta_tbl[#sta_tbl]
				local tag1=string.match(al_1,"[A-Z]")
				local tag2=string.match(sta_2,"[A-Z]")
				if tag1==tag2
					then
					k=k+1
				end
			end
		end

		return k==0
	end

	local al_t=cross_single_step(new_tbl,1)--第一个棱块
	al_end=(type(al_t)=="table" and al_t[1] or al_t)

	new_tbl={}

	surface=TDS.rubik_algorithm(surface,al_end,layer,a)
	new_tbl=state_table(surface)--新的状态表

	for i=2,4
		do
		new_tbl=state_table(surface)
		local al_temp=cross_single_step(new_tbl,i)
		if (al_temp~="" and type(al_temp)~="table")--未归位且不在顶层
			then
			if not(top_layer_check(surface,i-1,tbl,new_tbl))
				then
				local k=0
				repeat
					k=k+1
					surface=TDS.rubik_algorithm(surface,"U",layer,a)
					al_end=al_end.."U"
					new_tbl=state_table(surface)
				until (top_layer_check(surface,i-1,tbl,new_tbl)==true or k>4)
			end
			al_end=al_end..al_temp
			surface=TDS.rubik_algorithm(surface,al_temp,layer,a)
		elseif (type(al_temp)=="table" and string.match(new_tbl[i],"U"))--未归位但在顶层
			then
			local al_temp_tbl=TDS.rubik_algorithm_split(al_temp[1])
			local al_first=al_temp_tbl[1]--首先执行第一步
			surface=TDS.rubik_algorithm(surface,al_first,layer,a)
			al_end=al_end..al_first
			new_tbl=state_table(surface)
			if not(top_layer_check(surface,i-1,tbl,new_tbl))
				then
				local k=0
				repeat
					k=k+1
					surface=TDS.rubik_algorithm(surface,"U",layer,a)
					al_end=al_end.."U"
					new_tbl=state_table(surface)
				until (top_layer_check(surface,i-1,tbl,new_tbl)==true or k>4)
			end
			local cut=(string.match(new_tbl[i],"D") and #al_temp_tbl-1 or #al_temp_tbl-1)
			al_end=al_end..table.concat(al_temp_tbl,"",2,cut)
			surface=TDS.rubik_algorithm(surface,table.concat(al_temp_tbl,"",2,cut),layer,a)
		elseif (type(al_temp)=="table" and string.match(new_tbl[i],"D"))
			then
			if not(top_layer_check(surface,i-1,tbl,new_tbl,1))
				then
				local k=0
				repeat
					k=k+1
					surface=TDS.rubik_algorithm(surface,"U",layer,a)
					al_end=al_end.."U"
					new_tbl=state_table(surface)
				until (top_layer_check(surface,i-1,tbl,new_tbl,1)==true or k>4)
			end
			local al_temp_tbl=TDS.rubik_algorithm_split(al_temp[1])
			local al_first=al_temp_tbl[1]--首先执行第一步
			surface=TDS.rubik_algorithm(surface,al_first,layer,a)
			al_end=al_end..al_first
			new_tbl=state_table(surface)
			if not(top_layer_check(surface,i-1,tbl,new_tbl))
				then
				local k=0
				repeat
					k=k+1
					surface=TDS.rubik_algorithm(surface,"U",layer,a)
					al_end=al_end.."U"
					new_tbl=state_table(surface)
				until (top_layer_check(surface,i-1,tbl,new_tbl)==true or k>4)
			end
			local cut=(string.match(new_tbl[i],"D") and #al_temp_tbl-1 or #al_temp_tbl-1)
			al_end=al_end..table.concat(al_temp_tbl,"",2,cut)
			surface=TDS.rubik_algorithm(surface,table.concat(al_temp_tbl,"",2,cut),layer,a)

		end
	end
	
	surface=table.copy_deep(TDS.rubik_algorithm(sur,al_end,layer,a))
	new_tbl=state_table(surface)

	local function cross_step_2(surface,tbl,i)
		local vec0=tbl[i].vector
		local vec1=surface[tbl[i][1]].vector
		local angle=num(TDS.vector_angle(vec0,vec1))
		if angle==90
			then
			local n_v=TDS.outer_product(vec0,vec1)
			if n_v[1][3]<0
				then
				return "U'"..state_tbl[i].."2"
			else
				return "U"..state_tbl[i].."2"
			end
		elseif angle==0
			then
			return state_tbl[i].."2"
		else
			return "U2"..state_tbl[i].."2"
		end
	end

	for i=1,4
		do
		local al_t=cross_step_2(surface,tbl,i)
		al_end=al_end..al_t
		surface=TDS.rubik_algorithm(surface,al_t,layer,a)
		new_tbl=state_table(surface)
	end
	local al_end_inter=TDS.rubik_algorithm_intergrate(al_end)
	return al_end_inter,surface,new_tbl
end

TDS.rubik_solve_F1L=function(surface)
	local surface=table.copy_deep(surface)
	local sur=table.copy_deep(surface)
	a=90
	layer=3
	local al_end=""
	local DFR={21,36,45,state="DFR"}
	local DRB={27,39,12,state="DRB"}
	local DBL={25,10,46,state="DBL"}
	local DLF={19,52,34,state="DLF"}
	local tbl={DFR,DRB,DBL,DLF}
	local function dir(surface,tbl)--判断底色朝向
		local state=""
		for i=1,#tbl
			do
			local vec=table.copy_deep(surface[tbl[i]].vector)
			for k,v in pairs(n_vec)
				do
				local angle=TDS.vector_angle(vec,v)
				if num(angle)==0
					then
					state=state..k
				end
			end
		end
		return state
	end

	local function state_table(surface)
		local new_tbl={}
		for i=1,#tbl
			do
			new_tbl[i]=dir(surface,tbl[i])--记录四个块的目前朝向
		end
		return new_tbl
	end

	local new_tbl=state_table(surface)--计算初始底层棱块状态

	local function case_U(sur,state,tbl,i)
		local surface1=table.copy_deep(sur)
		local function top_layer_check(state,tbl,i)
			local s_n=string.gsub(state,"U","D")
			local s_0=tbl[i].state
			local p=0
			for s in string.gmatch(s_n,"[A-Z]")
				do
				if string.match(s_0,s)
					then
					p=p+1
				end
			end
			return p==3
		end
		if not(top_layer_check(state,tbl,i))
			then
			local k=0
			repeat
				k=k+1
				al_t=al_t.."U"
				surface1=TDS.rubik_algorithm(surface1,"U",layer,a)
				new_tbl=state_table(surface1)
			until (top_layer_check(new_tbl[i],tbl,i)==true or k>4)
		end
		new_tbl=state_table(surface1)
		local b_s=string.sub(new_tbl[i],1,1)
		if b_s=="U"
			then
			if (string.match(new_tbl[i],"[L]") and string.match(new_tbl[i],"[B]")) or (string.match(new_tbl[i],"[R]") and string.match(new_tbl[i],"[F]"))
				then
				local tag=string.match(new_tbl[i],"[RL]")
				al_t=al_t..tag.."U2"..tag.."'".."U'"..tag.."U"..tag.."'"
				surface1=TDS.rubik_algorithm(surface1,al_t,layer,a)
				new_tbl=state_table(surface1)
				al_end=al_end..al_t
			else
				local tag=string.match(new_tbl[i],"[RL]")
				al_t=al_t..tag.."'".."U2"..tag.."U"..tag.."'".."U'"..tag
				surface1=TDS.rubik_algorithm(surface1,al_t,layer,a)
				new_tbl=state_table(surface1)
				al_end=al_end..al_t
			end
		elseif b_s~="U"
			then
			if b_s=="L" or b_s=="R"
				then
				if (string.match(new_tbl[i],"[L]") and string.match(new_tbl[i],"[B]")) or (string.match(new_tbl[i],"[R]") and string.match(new_tbl[i],"[F]"))
					then
					al_t=al_t..b_s.."U"..b_s.."'"
					surface1=TDS.rubik_algorithm(surface1,al_t,layer,a)
					new_tbl=state_table(surface1)
					al_end=al_end..al_t
				else
					al_t=al_t..b_s.."'".."U'"..b_s
					surface1=TDS.rubik_algorithm(surface1,al_t,layer,a)
					new_tbl=state_table(surface1)
					al_end=al_end..al_t
				end
			elseif b_s=="B" or b_s=="F"
				then
				if string.match(new_tbl[i],"R")
					then
					al_t=al_t.."y"
					if string.match(new_tbl[i],"B")
						then
						al_t=al_t.."RUR'y'"
					else
						al_t=al_t.."L'U'Ly'"
					end
					surface1=TDS.rubik_algorithm(surface1,al_t,layer,a)
					new_tbl=state_table(surface1)
					al_end=al_end..al_t
				else
					al_t=al_t.."y'"
					if string.match(new_tbl[i],"F")
						then
						al_t=al_t.."RUR'y"
					else
						al_t=al_t.."L'U'Ly"
					end
					surface1=TDS.rubik_algorithm(surface1,al_t,layer,a)
					new_tbl=state_table(surface1)
					al_end=al_end..al_t
				end
			end
		end
		return al_end,al_t
	end
		local function case_D(sur,state,tbl,i)
		al_t=""
		local surface1=table.copy_deep(sur)
		if state~=tbl[i].state and string.match(state,"D")
			then
			local tag=string.match(state,"[RL]")
			if (string.match(state,"L") and string.match(state,"B")) or (string.match(state,"R") and string.match(state,"F"))
				then
				al_t=al_t..tag.."U"..tag.."'"
				surface1=TDS.rubik_algorithm(surface1,al_t,layer,a)
				new_tbl=state_table(surface1)
			else
				al_t=al_t..tag.."'".."U'"..tag
				surface1=TDS.rubik_algorithm(surface1,al_t,layer,a)
				new_tbl=state_table(surface1)
			end
		end
		return case_U(surface1,new_tbl[i],tbl,i)
	end
local al_tbl={}
	for i=1,4
		do
		new_tbl=state_table(sur)
		local al_end0,al_t=case_D(sur,new_tbl[i],tbl,i)
		al_tbl[#al_tbl+1]=al_t
		sur=TDS.rubik_algorithm(sur,al_t,layer,a)
		new_tbl=state_table(sur)
	end
	return al_end,new_tbl,sur,al_t,al_tbl
end

TDS.rubik_solve_F2L=function(surface)
	local sur=table.copy(surface)
	surface=table.copy_deep(surface)
	layer=3
	a=90
	local new_tbl={}
	local FR={33,44,state="FR"}
	local RB={38,15,state="RB"}
	local BL={13,47,state="BL"}
	local LF={53,31,state="LF"}
	local tbl={FR,RB,BL,LF}

	local function dir(surface,tbl)--判断色相
		local state=""
		for i=1,#tbl
			do
			local vec=table.copy_deep(surface[tbl[i]].vector)
			for k,v in pairs(n_vec)
				do
				local angle=TDS.vector_angle(vec,v)
				if num(angle)==0
					then
					state=state..k
				end
			end
		end
		return state
	end

	local function state_table(surface)
		local new_tbl={}
		for i=1,#tbl
			do
			new_tbl[i]=dir(surface,tbl[i])--记录四个块的目前朝向
		end
		return new_tbl
	end

	local new_tbl=state_table(surface)--计算初始第二层层棱块状态
	local y_tbl={{str="yy'",rad=0},{str="y",rad=90},{str="y2",rad=180},{str="y'",rad=-90}}

	local function F2L_case_U(surface,state,tbl,i)--棱块位于顶层
		if state~=tbl[i].state and string.match(state,"U")
			then
			local s1,s2=string.sub(state,1,1),string.sub(state,2,2)
			surface1=table.copy_deep(surface)
			surface1=TDS.rubik_algorithm(surface1,y_tbl[i].str,layer,a)
			al_t=al_t..y_tbl[i].str
			new_tbl=state_table(surface1)
			if s1~="U"
				then
				local k=0
				repeat
					k=k+1
					al_t=al_t.."U"
					surface1=TDS.rubik_algorithm(surface1,"U",layer,a)
					local vec1=table.copy_deep(surface1[tbl[i][1]].vector)
				until num(300*vec1[1][1])>0 or k>=4
				al_t=al_t.."URU'R'yU'L'ULy'"..TDS.rubik_algorithm_reverse(y_tbl[i].str)
			elseif s1=="U"
				then
				local k=0
				repeat
					k=k+1
					al_t=al_t.."U"
					surface1=TDS.rubik_algorithm(surface1,"U",layer,a)
					local vec1=table.copy_deep(surface1[tbl[i][2]].vector)
				until num(300*vec1[1][2])>0 or k>=4
				al_t=al_t.."R'F'RURU'R'F"..TDS.rubik_algorithm_reverse(y_tbl[i].str)
			end
			return al_t
		else
			return al_t
		end
	end

	function F2L_case_E(surface,state,tbl,i)--棱块位于中层
		al_t=""
		local state0=tbl[i].state
		if (state~=state0 and (not string.match(state,"U")))--如果棱块错误且不位于顶层，进入调整
			then
			if (string.reverse(state)==state0)--槽正确，色相错误
				then
				al_t=al_t..(i>1 and y_tbl[i].str or "").."RUR'U2RU2R'y'UR'U'Ry"..TDS.rubik_algorithm_reverse(y_tbl[i].str)
			else
				local tag=string.match(state,"[FB]")
				if tag=="F"
					then
					local tag2=string.match(state,"[RL]")
					if tag2=="R"
						then
						al_t=al_t.."RU'R'yU'L'ULy'"
					else
						al_t=al_t.."L'ULy'URU'R'y"
					end
				elseif tag=="B"
					then
					local tag2=string.match(state,"[RL]")
					if tag2=="L"
						then
						al_t=al_t.."y2RU'R'yU'L'ULy"
					else
						al_t=al_t.."y2L'ULy'URU'R'y'"
					end
				end
			end
			surface=TDS.rubik_algorithm(surface,al_t,layer,a)
			new_tbl=state_table(surface)
			return F2L_case_U(surface,new_tbl[i],tbl,i)
		else
			return F2L_case_U(surface,state,tbl,i)
		end
	end
	local al_t=""
	local al_tbl={}
	for i=1,4
		do
		new_tbl=state_table(surface)
		al_t=F2L_case_E(surface,new_tbl[i],tbl,i)
		al_tbl[#al_tbl+1]=al_t
		surface=TDS.rubik_algorithm(surface,al_t,layer,a)
		new_tbl=state_table(surface)
	end
	return new_tbl,al_t,surface,s0,al_tbl
end

TDS.rubik_solve_top_cross=function(surface)
	layer=3
	a=90
	local sur=table.copy_deep(surface)
	local UF={8,29,state="UF"}
	local UR={6,40,state="UR"}
	local UB={2,17,state="UB"}
	local UL={4,51,state="UL"}
	local tbl={UF,UR,UB,UL}
	local function dir(surface,tbl)--判断色相
		local state=""
		for i=1,#tbl
			do
			local vec=table.copy_deep(surface[tbl[i]].vector)
			for k,v in pairs(n_vec)
				do
				local angle=TDS.vector_angle(vec,v)
				if num(angle)==0
					then
					state=state..k
				end
			end
		end
		return state
	end

	local function state_table(surface)
		local new_tbl={}
		for i=1,#tbl
			do
			new_tbl[i]=dir(surface,tbl[i])--记录四个块的目前朝向
		end
		return new_tbl
	end

	local new_tbl=state_table(surface)--计算初始第二层层棱块状态

	local function top_dir_num(surface,tbl,s_tbl)
		local k=0
		local vec={}
		for i=1,4
			do
			local s11=string.sub(s_tbl[i],1,1)
			if s11=="U"
				then
				k=k+1
				local vec1=table.copy_deep(surface[tbl[i][2]].vector)
				local x,y=100*vec1[1][1],100*vec1[1][2]
				vec[#vec+1]={x=x,y=y}
			end
		end
		return k,vec
	end
	local al_t=""
	local function prepro(surface)
		local sur=table.copy_deep(surface)
		new_tbl=state_table(sur)
		local al_temp=""
		local top_n,vec=top_dir_num(sur,tbl,new_tbl)
		if top_n==0
			then
			al_temp=al_temp.."FRUR'U'F'"
			sur=TDS.rubik_algorithm(sur,al_temp,layer,a)
			new_tbl=state_table(sur)
		elseif top_n==2
			then
			if ((vec[1].y*vec[2].y)~=0 or (vec[1].x*vec[2].x)~=0)
				then
				al_temp=al_temp..(vec[1].y~=0 and "" or "U").."FRUR'U'F'"
				sur=TDS.rubik_algorithm(sur,al_temp,layer,a)
				new_tbl=state_table(sur)
			else
				if not((vec[1].x>0 and vec[2].y>0) or (vec[1].y>0 and vec[2].x>0))
					then
					local k=0
					repeat
						k=k+1
						sur=TDS.rubik_algorithm(sur,"U",layer,a)
						new_tbl=state_table(sur)
						_,vec=top_dir_num(sur,tbl,new_tbl)
						al_temp=al_temp.."U"
					until ((vec[1].x>0 and vec[2].y>0) or (vec[1].y>0 and vec[2].x>0)) or k>=4
					
				end
				sur=TDS.rubik_algorithm(sur,"FRUR'U'F'",layer,a)
					new_tbl=state_table(sur)
					al_temp=al_temp.."FRUR'U'F'"
			end
		elseif top_n==4
			then
			al_temp=""
		end
		return al_temp,top_n
	end
	local al_tbl={}
	local k1,v1=top_dir_num(sur,tbl,new_tbl)
	if k1~=4
		then
		local kp=0
		while(true)
			do
			kp=kp+1
			local al_temp,tn=prepro(sur)
			al_tbl[#al_tbl+1]=al_temp
			sur=TDS.rubik_algorithm(sur,al_temp,layer,a)
			new_tbl=state_table(sur)
			al_t=al_t..al_temp
			top_n=top_dir_num(sur,tbl,new_tbl)
			if top_n==4 or kp>=3
				then
				break
			end
		end
	end
	return sur,al_t,new_tbl,al_tbl
end


TDS.rubik_solve_OLL=function(surface)
	layer=3
	a=90
	local sur=table.copy_deep(surface)
	local U1={9,state="U"}
	local U2={3,state="U"}
	local U3={1,state="U"}
	local U4={7,state="U"}
	local tbl={U1,U2,U3,U4}
	local al_set={"RU'2R'U'RUR'U'RU'R'",
				"RU'2R2U'R2U'R'2U'2R",
				"rUR'U'r'FRF'",
				"R2D'RU'2R'DRU'2R",
				"FR'F'rURU'r'",
				"RU'2R'U'RU'R'",
				"LUL'ULU'2L'"
					}
	local function dir(surface,tbl)--判断色相
		local state=""
		for i=1,#tbl
			do
			local vec=table.copy_deep(surface[tbl[i]].vector)
			for k,v in pairs(n_vec)
				do
				local angle=TDS.vector_angle(vec,v)
				if num(angle)==0
					then
					state=state..k
				end
			end
		end
		return state
	end

	local function state_table(surface)
		local new_tbl={}
		for i=1,#tbl
			do
			new_tbl[i]=dir(surface,tbl[i])--记录四个块的目前朝向
		end
		return new_tbl
	end

	local new_tbl=state_table(sur)--计算初始顶层角块状态

	local function top_num(surface,tbl,s_tbl)
		local k=0
		local vec={}
		for i=1,#s_tbl
			do
			if s_tbl[i]~="U"
				then
				k=k+1
				local vec1=table.copy_deep(surface[tbl[i][1]].vector)
				local x1,y1=num(100*vec1[1][1]),num(100*vec1[1][2])
				vec[#vec+1]={x=x1,y=y1,k=tbl[i][1]}
			end
		end
		return k,vec
	end

	local function state_select(s_tbl)
		local n_tbl={}
		for i=1,#s_tbl
			do
			if s_tbl[i]~="U"
				then
				n_tbl[#n_tbl+1]=s_tbl[i]
			end
		end
		return n_tbl
	end

	local function state_concat(s_tbl)
		local n0=state_select(s_tbl)
		table.sort(n0,function(a,b) return string.byte(a)>string.byte(b) end)
		local n_tbl={}
		local tag=""
		n_tbl[1]=(n0 and n0[1] or "")
		if n0
			then
			for i=2,#n0
				do
				if n0[i]~=n0[i-1]
					then
					n_tbl[#n_tbl+1]=n0[i]
				else
					n_tbl[#n_tbl]=n_tbl[#n_tbl]..n0[i]
				end
			end
		end
		for i=1,#n_tbl
			do
			if string.len(n_tbl[i])==2
				then
				tag=n_tbl[i]
				break
			end
		end
		return n_tbl,tag
	end

	local al_t=""

	local k0,vec0=top_num(sur,tbl,new_tbl)
	if k0==4
		then
		local x1,x2,x3,x4=vec0[1].x,vec0[2].x,vec0[3].x,vec0[4].x
		local y1,y2,y3,y4=vec0[1].y,vec0[2].y,vec0[3].y,vec0[4].y
		if (x1~=0 and x2~=0 and x3~=0 and x4~=0) or (y1~=0 and y2~=0 and y3~=0 and y4~=0)
			then
			al_t=al_t..(y1~=0 and "U" or "")..al_set[1]
		else
			local n_tbl,tag=state_concat(new_tbl)
			tag1=string.sub(tag,1,1)
			al_t=al_t..((tag1=="L") and "" or (tag1=="R") and "U2" or (tag1=="F") and "U" or "U'")..al_set[2]
		end
	elseif k0==2
		then
		local n_tbl,tag=state_concat(new_tbl)
		if #n_tbl==1
			then
			local tag1=string.match(tag,"[LBRF]")
			al_t=al_t..(tag1=="L" and "U" or (tag1=="R") and "U'" or (tag1=="F") and "U2" or "")..al_set[4]
		else
			local x1,x2=vec0[1].x,vec0[2].x
			local y1,y2=vec0[1].y,vec0[2].y
			if (x1~=0 and x2~=0) or (y1~=0 and y2~=0)
				then
				local x3,y3,z3,x4,y4,z4=TDS.shape.bounding(sur[vec0[1].k].shape)
				local x0,y0=num(100*(x3+x4)/2),num(100*(y3+y4)/2)
				local al_temp=((x1~=0 and x2~=0 and y0>0) and "U2" or (x1~=0 and x2~=0 and y0<0) and "" or (y1~=0 and y2~=0 and x0<0) and "U'" or "U")..al_set[3]
				al_t=al_t..al_temp
			else
				local state=concat(state_select(new_tbl))
				if state=="RF" or state=="FR"
					then
					al_t=al_t..al_set[5]
				elseif state=="RB" or state=="BR"
					then
					al_t=al_t.."U"..al_set[5]
				elseif state=="BL" or state=="LB"
					then
					al_t=al_t.."U2"..al_set[5]
				else
					al_t=al_t.."U'"..al_set[5]
				end
			end
		end
	elseif k0==3
		then
		local tag_k=1
		for i=1,4
			do
			if new_tbl[i]=="U"
				then
				tag_k=tbl[i][1]
				break
			end
		end
		local x3,y3,z3,x4,y4,z4=TDS.shape.bounding(sur[tag_k].shape)
		local x0,y0=num(100*(x3+x4)/2),num(100*(y3+y4)/2)
		if (x0<0 and y0<0)
			then
			al_t=al_t.."U"
		elseif (x0>0 and y0>0)
			then
			al_t=al_t.."U'"
		elseif (x0>0 and y0<0)
			then
			al_t=al_t.."U2"
		else
			al_t=al_t
		end
		local new_tbl1=state_table(TDS.rubik_algorithm(sur,al_t,layer,a))
		local state=concat(state_select(new_tbl1))
		if string.match(state,"B")
			then
			al_t=al_t..al_set[7]
		else
			al_t=al_t..al_set[6]
		end
	end
	sur=TDS.rubik_algorithm(sur,al_t,layer,a)
	new_tbl=state_table(sur)
	return sur,new_tbl,al_t
end

local F0={28,29,30,state="F"}
local R0={43,40,37,state="R"}
local B0={18,16,17,state="B"}
local L0={48,51,54,state="L"}

TDS.rubik_solve_PLL=function(surface)
	layer=3
	a=90
	local sur=table.copy_deep(surface)
	local F={28,30,state="F"}
	local R={43,37,state="R"}
	local B={18,16,state="B"}
	local L={48,54,state="L"}
	local tbl={F,R,B,L}
	local function dir(surface,tbl)--判断色相
		local state=""
		for i=1,#tbl
			do
			local vec=table.copy_deep(surface[tbl[i]].vector)
			for k,v in pairs(n_vec)
				do
				local angle=TDS.vector_angle(vec,v)
				if num(angle)==0
					then
					state=state..k
				end
			end
		end
		return state
	end

	local function state_table(surface)
		local new_tbl={}
		for i=1,#tbl
			do
			new_tbl[i]=dir(surface,tbl[i])--记录四个块的目前朝向
		end
		return new_tbl
	end

	local function str_to_tbl(state)
		local s_tbl={}
		local n_tbl={}
		for s in string.gmatch(state,"[A-Z]")
			do
			s_tbl[#s_tbl+1]=s
		end
		n_tbl[1]=s_tbl[1]
		for i=2,#s_tbl
			do
			if s_tbl[i]~=s_tbl[i-1]
				then
				n_tbl[#n_tbl+1]=s_tbl[i]
			else
				n_tbl[#n_tbl]=n_tbl[#n_tbl]..s_tbl[i]
			end
		end
		return n_tbl
	end

	local new_tbl=state_table(sur)--获取角块色相
	al_t=""
	local n_tbl={}
	local function find_case_corner(new_tbl)
		local c_tbl={{c=0,tag={},state={}},{c=0,tag={},state={}}}
		for i=1,#new_tbl
			do
			local tbl0=str_to_tbl(new_tbl[i])
			n_tbl[i]=table.copy_deep(tbl0)
			if #tbl0==1
				then
				c_tbl[1].c=c_tbl[1].c+1
				c_tbl[1].state[#c_tbl[1].state+1]=string.sub(new_tbl[i],1,1)
				c_tbl[1].state[#c_tbl[1].state+1]=string.sub(new_tbl[i],2,2)
				for p=1,2
					do
					c_tbl[1].tag[#c_tbl[1].tag+1]=tbl[i][p]
				end
			elseif #tbl0==2
				then
				c_tbl[2].c=c_tbl[2].c+1
				c_tbl[2].state[#c_tbl[2].state+1]=string.sub(new_tbl[i],1,1)
				c_tbl[2].state[#c_tbl[2].state+1]=string.sub(new_tbl[i],2,2)
				for p=1,2
					do
					c_tbl[2].tag[#c_tbl[2].tag+1]=tbl[i][p]
				end
			end
		end
		return c_tbl
	end

	local al_set1={"x'R2D'2R'U'RD'2R'UR'x"}

	local function case_true(state)
		local al_t=""
		state=string.sub(state,1,1)
		if state=="R"
			then
			al_t=al_t..al_set1[1]
		elseif state=="L"
			then
			al_t=al_t.."U2"..al_set1[1]
		elseif state=="B"
			then
			al_t=al_t.."U"..al_set1[1]
		elseif state=="F"
			then
			al_t=al_t.."U'"..al_set1[1]
		end
		return al_t
	end

	c_tbl=find_case_corner(new_tbl)
	if c_tbl[1].c==1
		then
		local state=c_tbl[1].state[1]
		local al_temp=case_true(state)
		al_t=al_t..al_temp
	elseif c_tbl[1].c==4
		then
		al_t=""
	else
		local sur1=TDS.rubik_algorithm(sur,al_set1[1],layer,a)
		new_tbl=state_table(sur1)
		c_tbl1=find_case_corner(new_tbl)
		local state=c_tbl1[1].state[1]
		local al_temp=case_true(state)
		al_t=al_t..al_set1[1]..al_temp
	end
	sur=TDS.rubik_algorithm(sur,al_t,layer,a)
	dir1=string.sub(dir(sur,tbl[1]),1,1)
	local AUF=(dir1=="F" and "yy'" or (dir1=="B") and "U2" or (dir1=="L") and "U'" or "U")
	sur=TDS.rubik_algorithm(sur,AUF,layer,a)
	al_t=al_t..AUF
	return sur,new_tbl,al_t,c_tbl
end

TDS.rubik_solve_PLL2=function(surface)
	layer=3
	a=90
	local sur=table.copy_deep(surface)
	local F={29,state="F"}
	local R={40,state="R"}
	local B={17,state="B"}
	local L={51,state="L"}
	local tbl={F,R,B,L}
	local function dir(surface,tbl)--判断色相
		local state=""
		for i=1,#tbl
			do
			local vec=table.copy_deep(surface[tbl[i]].vector)
			for k,v in pairs(n_vec)
				do
				local angle=TDS.vector_angle(vec,v)
				if num(angle)==0
					then
					state=state..k
				end
			end
		end
		return state
	end

	local function state_table(surface)
		local new_tbl={}
		for i=1,#tbl
			do
			new_tbl[i]=dir(surface,tbl[i])--记录四个块的目前朝向
		end
		return new_tbl
	end

	local new_tbl=state_table(sur)

	local function find_state(new_tbl)
		local tbl1={}
		local k=0
		for i=1,#new_tbl
			do
			if new_tbl[i]==tbl[i].state
				then
				k=k+1
				tbl1[#tbl1+1]=tbl[i].state..new_tbl[i]
			end
		end
		return k,tbl1
	end

	al_t=""

	local al_set={"RU'RURURU'R'U'R2","R2URUR'U'R'U'R'UR'","M'2U'M'2U'2M'2U'M'2","M'2U'M'2U'M'U'2M'2U'2M'U'2","M'2U'2M'U'M'2U'M'2U'M'U"}

	k,tbl1=find_state(new_tbl)
	if k==4
		then 
		al_t=""
	elseif k==1
		then
		local tag=string.sub(tbl1[1],1,1)
		al_temp=(tag=="R" and "y'" or (tag=="L") and "y" or (tag=="F") and "y2" or "")
		sur=TDS.rubik_algorithm(sur,al_temp,layer,a)
		local tag_k=(al_temp=="y" and 1 or (al_temp=="y2") and 2 or (al_temp=="y'") and 3 or 4)
		local x1,y1,z1,x2,y2,z2=TDS.shape.bounding(sur[tbl[tag_k][1]].shape)
		local x0,y0=num(x1+x2/2),num(y1+y2/2)
		local sx,sy=a,0
		local jx,jy=(sx-x0),(sy-y0)
		if jx>0
			then
			al_t=al_t..al_set[1]
		else
			al_t=al_t..al_set[2]
		end
	else
		local tag=new_tbl[1]
		if tag=="R"
			then
			al_t=al_t..al_set[5]
		elseif tag=="L"
			then
			al_t=al_t..al_set[4]
		else
			al_t=al_t..al_set[3]
		end
	end
	sur=TDS.rubik_algorithm(sur,al_t,layer,a)
	new_tbl=state_table(sur)
	al_t=(al_temp and al_temp or "")..al_t
	return new_tbl,sur
end

function get_alpha(alpha)
	local err="wrong input to function:Kalpha.get_alpha(alpha)\n"
	kbug(err,alpha,"alpha",{"string","number"})
	if type(alpha)=="string"
		then
		local al=string.gsub(alpha,"[H&h]","")
		return tonumber(al,16)
	elseif type(alpha)=="number"
		then
		return math.range(alpha,0,255)
	end
end

function alpha_tag(alpha)
	local err="wrong input to function:Kalpha.tag(alpha)\n"
	kbug(err,alpha,"alpha","number")
	return string.format("&H%.2X&",math.range(alpha,0,255))
end

function alpha_max(...)
	local err="wrong input to function:Kalpha.max(alpha)\n"
	local tbl={...}
	local al=0
	for i=1,#tbl
		do
		kbug(err,tbl[i],"alpha",{"number","string"})
		local al1=get_alpha(tbl[i])
		al=math.max(al,al1)
	end
	return alpha_tag(al)
end

function alpha_min(...)
	local err="wrong input to function:Kalpha.min(alpha)\n"
	local tbl={...}
	local al=255
	for i=1,#tbl
		do
		kbug(err,tbl[i],"alpha",{"number","string"})
		local al1=get_alpha(tbl[i])
		al=math.min(al,al1)
	end
	return alpha_tag(al)
end

function alpha_add(alpha1,alpha2)
	local err="wrong input to function:Kalpha.add(alpha1,alpha2)\n"
	kbug(err,alpha1,"alpha1",{"number","string"})
	kbug(err,alpha2,"alpha2",{"number","string"})
	return alpha_tag(get_alpha(alpha1)+get_alpha(alpha2))
end

function alpha_sub(alpha1,alpha2)
	local err="wrong input to function:Kalpha.sub(alpha1,alpha2)\n"
	kbug(err,alpha1,"alpha1",{"number","string"})
	kbug(err,alpha2,"alpha2",{"number","string"})
	return alpha_tag(get_alpha(alpha1)-get_alpha(alpha2))
end

function interpolate_alpha1(alpha1,alpha2,t)
	local err="wrong input to function:Kalpha.gradient(alpha1,alpha2,t)\n"
	kbug(err,alpha1,"alpha1",{"number","string"})
	kbug(err,alpha2,"alpha2",{"number","string"})
	kbug(err,t,"t","number")
	local al1=get_alpha(alpha1)
	local al2=get_alpha(alpha2)
	return alpha_tag(al1*(1-t)+al2*t)
end

function poly_count(tbl,x)--number，多项式计算
	if #tbl==1
		then
		return tbl[1]
	else
		local x_n=tbl[1]
		table.remove(tbl,1)
		return x*poly_count(tbl,x)+x_n
	end
end

function DFT(sequence,k)
	local sum_R,sum_I=0,0
	for i=1,#sequence
		do
		sum_R=sum_R+sequence[i]*math.cos(2*math.pi*k*(i-1)/#sequence)
		sum_I=sum_I-sequence[i]*math.sin(2*math.pi*k*(i-1)/#sequence)
	end
	return {sum_R,sum_I}
end

PAC={}
PAC.permu=function(tbl)
	local function reverse(tbl)
		local new_tbl={}
		for i=1,#tbl
			do
			new_tbl[i]=tbl[#tbl-i+1]
		end
		return new_tbl
	end
	if #tbl<=2
		then
		return table.add(tbl,reverse(tbl))
	else
		local tbl2={}
		for i=1,#tbl
			do
			local new_tbl=table.copy_deep(tbl)
			table.remove(new_tbl,i)
			local new_tbl1=PAC.permu(new_tbl)
			tbl2=table.add(tbl2,new_tbl1)
		end
		return tbl2
	end
end

----------------------------以下为逻辑函数相关定义--------------------
logic={}

logic.to_boolean=function (value)
	return (value and true or false)
end

logic.to_value=function (value)
	return ((value and value~=0 and value~=nil) and 1 or 0)
end

logic.OR=function (...)
	local len=select("#",...)
	local tbl={...}
	local sum=0
	for i=1,len
		do
		sum=sum+logic.to_value(tbl[i])
	end
	return (sum>0 and 1 or 0)
end

logic.AND=function (...)
	local len=select("#",...)
	local tbl={...}
	local sum=1
	for i=1,len
		do
		sum=sum*logic.to_value(tbl[i])
	end
	return (sum>0 and 1 or 0)
end

logic.NOT=function (A)
	A=logic.to_value(A)
	return (A>0 and 0 or 1)
end

logic.XOR_pair1=function (A,B)
	return logic.OR(logic.AND(logic.NOT(A),B),logic.AND(logic.NOT(B),A))
end

logic.XOR=function (...)
	local len=select("#",...)
	local tbl={...}
	local sum
	for i=2,len
		do
		sum=logic.XOR_pair1(tbl[i],tbl[i-1])
	end
	return sum
end

logic.NAND=function(...)
	return logic.NOT(logic.AND(...))
end

logic.NOR=function(...)
	return logic.NOT(logic.OR(...))
end

function autotag(tag1,tag2,duration,t1,t2,t3,t4,t5)
	tag1="\\"..tag1
	tag2="\\"..tag2
	local T=t1+t2+t3+t4
	local dur_real=duration-t5
	local n=math.floor(dur_real/T)
	nt=dur_real-n*T
	local str=""
	for i=1,n
		do
		str=str..string.format("%s\\t(%d,%d,%s)\\t(%d,%d,%s)",i==1 and tag1 or "",(i-1)*T+t5,(i-1)*T+t5+t1,tag2,(i-1)*T+t5+t1+t2,i*T+t5-t4,tag1)
	end
	if nt>=t1+t2+t3
		then
		str=str..string.format("\\t(%d,%d,%s)\\t(%d,%d,%s)",n*T,n*T+t1,tag2,n*T+t1+t2,n*T+T-t4,tag1)
	elseif nt>=t1
		then
		str=str..string.format("\\t(%d,%d,%s)",n*T,n*T+t1,tag2)
	end
	return str
end

function autotag_rand(tag,para1,para2,duration,t1,t2,t3,t4,t5)
	local function tag_generate(tag,para1,para2)
		if type(para1)=="number" or type(para1)=="string"
			then
			if tag=="1a" or tag=="2a" or tag=="3a" or tag=="4a" or tag=="alpha"
				then
				return "\\"..tag..alpha_tag(math.random(para1,para2))
			elseif tag=="1c" or tag=="2c" or tag=="3c" or tag=="4c" or tag=="c"
				then
				return "\\"..tag..color_gradient(para1,para2,math.random())
			else
				return "\\"..tag..math.random(para1,para2)
			end
		else
			local k=0
			local str=""
			for s in string.gmatch(tag,"[^\\]+")
				do
				k=k+1
				if s=="1a" or s=="2a" or s=="3a" or s=="4a" or s=="alpha"
					then
					str=str.."\\"..s..alpha_tag(math.random(para1[k],para2[k]))
				elseif s=="1c" or s=="2c" or s=="3c" or s=="4c" or s=="c"
					then
					str=str.."\\"..s..color_gradient(para1[k],para2[k],math.random())
				else
					str=str.."\\"..s..math.random(para1[k],para2[k])
				end
			end
			return str
		end
	end
	local T=t1+t2+t3+t4
	local dur_real=duration-t5
	local n=math.floor(dur_real/T)
	nt=dur_real-n*T
	local str=""
	for i=1,n
		do
		local tag1=tag_generate(tag,para1,para2)
		local tag2=tag_generate(tag,para1,para2)
		str=str..string.format("%s\\t(%d,%d,%s)\\t(%d,%d,%s)",i==1 and tag1 or "",(i-1)*T+t5,(i-1)*T+t5+t1,tag2,(i-1)*T+t5+t1+t2,i*T+t5-t4,tag1)
	end
	if nt>=t1+t2+t3
		then
		local tag1=tag_generate(tag,para1,para2)
		local tag2=tag_generate(tag,para1,para2)
		str=str..string.format("\\t(%d,%d,%s)\\t(%d,%d,%s)",n*T,n*T+t1,tag2,n*T+t1+t2,n*T+T-t4,tag1)
	elseif nt>=t1
		then
		local tag2=tag_generate(tag,para1,para2)
		str=str..string.format("\\t(%d,%d,%s)",n*T,n*T+t1,tag2)
	end
	return str
end

function autotag_iso(tag1,tag2,duration,t1,t2,t3,t4,t5,dt)
	if dt==0
		then
		return autotag(tag1,tag2,duration,t1,t2,t3,t4,t5)
	else
		tag1="\\"..tag1
		tag2="\\"..tag2
		local dur_real=duration-t5
		local T0=t1+t2+t3+t4
		local n=math.floor((dur_real-T0*dt)/(dt^2))+1
		local tag=""
		for i=1,n
			do
			local st1=t5+(i==1 and 0 or T0*dt+(i-2)*(dt^2))
			local et1=st1+t1+(i-1)*dt
			local st2=et1+t2
			local et2=st2+t3+(i-1)*dt
			tag=tag..string.format("%s\\t(%d,%d,%s)\\t(%d,%d,%s)",(i==1 and tag1 or ""),st1,et1,tag2,st2,et2,tag1)
		end
		return tag
	end
end
