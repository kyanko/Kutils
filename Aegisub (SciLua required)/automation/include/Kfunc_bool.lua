Kfunc=require("Kfunc")
shape=require("shape")
Yutils=require("Yutils")

------输出格式：output={intersect,union,ass_shape1-ass_shape2,ass_shae2-ass_shape1}------

function shape.to_polygon(ass_shape)--将独立的命令连接为一个多边形并标准化
	local str=ass_shape
	str=string.gsub(str,"m","l")
	str=string.gsub(str,"l","m",1)
	str=shape.filter(str,function(x,y) return num(x),num(y) end)
	return str
end

function shape.get_intersect_point(ass_shape1,ass_shape2)--获取2个单部件多边形交点
	----确保单部件图形方向绘图相同(否则会影响边的连接，导致错误的运算)----
	local mea1,jud1=shape.measure(ass_shape1)
	local mea2,jud2=shape.measure(ass_shape2)
	if (not jud1)
		then
		ass_shape1=shape.reverse(ass_shape1)
	end
	if (not jud2)
		then
		ass_shape2=shape.reverse(ass_shape2)
	end

	local function get_vector(ass_shape)--获取直线命令并储存起始点和终点信息
		local vector={}
		for s in string.gmatch(ass_shape,"[a-z][^a-z]+")
			do
			local pos=get_pos(s)--获取命令点坐标
			vector[#vector+1]={str=s,ex=pos.x[#pos.x],ey=pos.y[#pos.y],inter={},vec={}}--首先储存结束点
		end
		for i=2,#vector+1
			do
			local pos=get_pos(vector[i-1].str)
			vector[math.fmod(i-1,#vector)+1].sx,vector[math.fmod(i-1,#vector)+1].sy=pos.x[#pos.x],pos.y[#pos.y]--储存起始点(实际为前一条命令的结束点)
		end
		return vector
	end

	--保证图形为多边形(若有曲线则flatten)--
	ass_shape1=(string.match(ass_shape1,"b") and shape.delete_same_path(shape.flat(ass_shape1)) or shape.delete_same_path(ass_shape1))
	ass_shape2=(string.match(ass_shape2,"b") and shape.delete_same_path(shape.flat(ass_shape2)) or shape.delete_same_path(ass_shape2))

	local vec1,vec2=get_vector(ass_shape1),get_vector(ass_shape2)--获取两个图形的命令与点集信息表

	local function line_formula(x1,y1,x2,y2)--A,B,C,Ax+By+C=0
		if (x1==x2)
			then
			return 1,0,-x1
		else
			local k=(y2-y1)/(x2-x1)
			local b=y1-k*x1
			if num(k)>0
				then
				return k,-1,b
			else
				return -k,1,-b
			end
		end
	end

	local function line_inter(x1,y1,x2,y2,x3,y3,x4,y4)--计算直线交点
		x1,y1,x2,y2,x3,y3,x4,y4=tonumber(x1),tonumber(y1),tonumber(x2),tonumber(y2),tonumber(x3),tonumber(y3),tonumber(x4),tonumber(y4)
		if (x1==x2 and x3==x4)--斜率均不存在
			then
			return false
		elseif (x1~=x2 and x3~=x4)--斜率均存在
			then
			local k1,k2=(y2-y1)/(x2-x1),(y4-y3)/(x4-x3)
			local b1,b2=y1-k1*x1,y3-k2*x3
			if k1==k2
				then return false
			else
				local ix=(b2-b1)/(k1-k2)
				return ix,k1*ix+b1
			end
		elseif (x1==x2 and x3~=x4)--直线1斜率不存在，直线2斜率存在
			then
			local k2=(y4-y3)/(x4-x3)
			local b2=y3-k2*x3
			return x1,k2*x1+b2
		elseif (x1~=x2 and x3==x4)--直线2斜率不存在，直线1斜率存在
			then	
			local k1=(y2-y1)/(x2-x1)
			local b1=y1-k1*x1
			return x3,k1*x3+b1
		end
	end

	local function vector_side_judge(inter1,inter2,inter)
		local x1,y1,x2,y2=inter1.sx,inter1.sy,inter1.ex,inter1.ey--线段1
		local x3,y3,x4,y4=inter2.sx,inter2.sy,inter2.ex,inter2.ey--线段2
		local x5,y5,x6,y6=inter.sx,inter.sy,inter.ex,inter.ey--被交线段
	end

	local function get_intersection(vector1,vector2)--计算绘图命令代表的线段交点
		local x1,y1,x2,y2=vector1.sx,vector1.sy,vector1.ex,vector1.ey
		local x3,y3,x4,y4=vector2.sx,vector2.sy,vector2.ex,vector2.ey
		local ix,iy=line_inter(x1,y1,x2,y2,x3,y3,x4,y4)
		if ix
			then
			local xj1,yj1,xj2,yj2=num((ix-x1)*(ix-x2)),num((iy-y1)*(iy-y2)),num((ix-x3)*(ix-x4)),num((iy-y3)*(iy-y4))--避免浮点误差
			if ((xj1<=0 and yj1<=0 and xj2<0 and yj2<0) or (xj1<0 and yj1<0 and xj2<=0 and yj2<=0))--交点位于线段中部
				then
				return num(ix),num(iy)
			
			else
				return false
			end
		end
	end

	local function vec_intersect(vector1,vector2)--计算交点坐标，交点数量以及对应边序列
		local intersect_n=0
		for i=1,#vector1
			do
			for p=1,#vector2
				do
				local ix,iy=get_intersection(vector1[i],vector2[p])
				if type(ix)=="number"
					then
					intersect_n=intersect_n+1
					vector1[i].inter[#vector1[i].inter+1]={x=num(ix),y=num(iy)}
				end
			end
		end
		return vector1,intersect_n
	end

	vec1,intersect_n=vec_intersect(vec1,vec2)--此处intersect_n为交点总数(一定为偶数)
	vec2,intersect_n2=vec_intersect(vec2,vec1)


	local function split_by_intersect(vector)--将线段按照交点做分割
		for i=1,#vector
			do
			local x1,y1,x2,y2=vector[i].sx,vector[i].sy,vector[i].ex,vector[i].ey
			table.sort(vector[i].inter,
				function (a,b)
					if x1<x2 then return a.x<b.x
					elseif (x1>x2) then return a.x>b.x
					else
					if (y1<y2) then return a.y<b.y
					else return a.y>b.y
					end
				end 
			end)--将交点原绘图命令起始点结束点顺序重排
			for p=1,#vector[i].inter+1
				do
				vector[i].vec[p]={str,include}
				if p<#vector[i].inter+1
					then
					vector[i].vec[p].str="l "..vector[i].inter[p].x.." "..vector[i].inter[p].y.." "--拆分原始直线命令并储存进新的信息表中
				else
					vector[i].vec[p].str=vector[i].str
				end
			end
		end
		return vector
	end

	return split_by_intersect(vec1),split_by_intersect(vec2),intersect_n
end

function shape.intersect_single(ass_shape1,ass_shape2)
	local vec1,vec2,intersect_n=shape.get_intersect_point(ass_shape1,ass_shape2)

	local function vec_include(vector,ass_shape)--判断边属性(在另外一方绘图的内部还是外部)
		for i=1,#vector
			do
			local x1,y1=vector[i].sx,vector[i].sy
			local pos=get_pos(vector[i].vec[1].str)
			local x2,y2=pos.x[1],pos.y[1]
			local x0,y0=num((x1+x2)/2),num((y1+y2)/2)
			local jud=shape.contains_point_test(ass_shape,x0,y0)
			for p=1,#vector[i].vec
				do
				vector[i].vec[p].include=(((tostring(jud)=="false" and p%2==1) or (tostring(jud)=="true" and p%2==0)) and "out" or "in")
			end
		end
		return vector
	end

	if intersect_n<-2
		then
		local x0,y0=string.match(ass_shape1,"(-?[%d.]+) (-?[%d.]+)")
		local x1,y1=string.match(ass_shape2,"(-?[%d.]+) (-?[%d.]+)")
		x0,y0=tonumber(x0),tonumber(y0)
		x1,y1=tonumber(x1),tonumber(y1)
		local jud1,jud2=shape.is_include(ass_shape2,ass_shape1),shape.is_include(ass_shape1,ass_shape2)
		local mea1=shape.measure(ass_shape1)
		local mea2=shape.measure(ass_shape2)
		if ((not jud1) and (not jud2))
			then
			return {ass_shape1..ass_shape2,"",ass_shape1,ass_shape2,ass_shape1..ass_shape2}
		else
			return (mea1<mea2 and {ass_shape2,ass_shape1,"",ass_shape2.." "..shape.reverse(ass_shape1),ass_shape2.." "..shape.reverse(ass_shape1)} or {ass_shape1,ass_shape2,ass_shape1.." "..ass_shape2,"",ass_shape1.." "..ass_shape2})
		end
	else
		vec1=vec_include(vec1,ass_shape2)
		vec2=vec_include(vec2,ass_shape1)

		v_c1,v_c2=table.copy_deep(vec1),table.copy_deep(vec2)

		local function vec_link(vector)--将新边分为若干段，每段严格为内部或者外部
			local tbl={}
			local k=1
			local new_vec={}
			for i=1,intersect_n+1
				do
				new_vec[i]={str,include,sx,sy}
			end
			new_vec[1]={str=vector[1].vec[1].str,include=vector[1].vec[1].include}
			for i=1,#vector
				do
				tbl[#tbl+1]=#vector[i].vec
			end
			local l,max=loop_n2(tbl)
			for i=2,max
				do
				local j1=l[i].j1
				local j2=l[i].j2
				local j1_pre=l[i-1].j1
				local j2_pre=l[i-1].j2
				if vector[j2].vec[j1].include~=vector[j2_pre].vec[j1_pre].include
					then
					k=k+1
					new_vec[k]=(new_vec[k] and new_vec[k] or {})
				end
				new_vec[k].str,new_vec[k].include=(new_vec[k].str and new_vec[k].str or "")..vector[j2].vec[j1].str.." ",vector[j2].vec[j1].include
			end
			if new_vec[1].include==new_vec[#new_vec].include
				then
				new_vec[1].str=new_vec[#new_vec].str..new_vec[1].str.." "
				table.remove(new_vec,#new_vec)
			end
			for i=2,#new_vec+1
				do
				local pos=get_pos(new_vec[i-1].str)
				local ir=math.fmod(i-1,#new_vec)+1
				local epos=get_pos(new_vec[ir].str)
				new_vec[ir].sx,new_vec[ir].sy=pos.x[#pos.x],pos.y[#pos.y]
				new_vec[ir].ex,new_vec[ir].ey=epos.x[#epos.x],epos.y[#epos.y]
			end
			return new_vec
		end

		vec1,vec2=vec_link(vec1),vec_link(vec2)--分段连接

		local function vector_adjust(vec,set)
			local new_vec={}
			local v_t=table.copy_deep(vec)
			for i=1,#v_t
				do
				new_vec[i]=v_t[math.fmod_real(i-1+set,#v_t,"loop")+1]
			end
			return new_vec
		end
		if vec1[1].include~="out"--将两组边集合调整(首段必须是外部边)
			then
			vec1=vector_adjust(vec1,1)
		end
		if vec2[1].include~="out"
			then
			vec2=vector_adjust(vec2,1)
		end
		
		local function to_inter(vec)--坐标全部取整标准化
			for i=1,#vec
				do
				vec[i].str=shape.filter(vec[i].str,function(x,y) return num(x),num(y) end)
				vec[i].sx,vec[i].sy=num(vec[i].sx),num(vec[i].sy)
				vec[i].ex,vec[i].ey=num(vec[i].ex),num(vec[i].ey)
			end
			return vec
		end

		local function vector_group(vector)--将边信息表分为奇偶两组
			local new_vec={odd={},even={}}
			local vec=table.copy_deep(vector)
			for i=1,#vec
				do
				if i%2==1
					then
					new_vec.odd[#new_vec.odd+1]=vec[i]
				else
					new_vec.even[#new_vec.even+1]=vec[i]
				end
			end
			return new_vec
		end

		vec1,vec2=to_inter(vec1),to_inter(vec2)--标准化

		local function vector_same_start(vector1,vector2)	
			local tag=vector1[1].include
			local tx,ty=vector1[1].sx,vector1[1].sy
			tk=1
			for i=1,#vector2--调整vec2使两者第一条边对应，方便后续连接
				do
				if (vector2[i].include==tag and vector2[i].ex==tx and vector2[i].ey==ty)
					then
					tk=i
				end
			end
			local v_t=table.copy_deep(vector2)
			local new_vec={}
			for i=1,#v_t
				do
				new_vec[i]=v_t[math.fmod_real(i+tk-2,#v_t)+1]
			end
			return new_vec
		end

		new_vec1,new_vec2=vector_group(vec1),vector_group(vec2)

		local function vector_reverse(vec)--针对减法做绘图反向
			local v_t=table.copy_deep(vec)
			for i=1,#v_t
				do
				local sx,sy=v_t[i].sx,v_t[i].sy
				v_t[i].str="m "..tostring(sx).." "..tostring(sy).." "..v_t[i].str
				v_t[i].str=shape.reverse_single(v_t[i].str)
				v_t[i].str=string.gsub(v_t[i].str,"[a-z][^a-z]+","",1)
				v_t[i].sx,v_t[i].ex=v_t[i].ex,v_t[i].sx
				v_t[i].sy,v_t[i].ey=v_t[i].ey,v_t[i].sy
			end
			return v_t
		end

		local function vector_empty_check(vec)--检查命令是否已全部连接
			local k=0
			for i=1,#vec
				do
				if vec[i].connect
					then
					k=k+1
				end
			end
			return k>0
		end

		local function vector_add_boolean(vec)--在边表里加入布尔值做连接判断
			for i=1,#vec
				do
				vec[i].connect=true
			end
			return vec
		end

		local function vector_to_polygon(vec)
			for i=1,#vec
				do
				vec[i]=shape.to_polygon(vec[i])
			end
			return vec
		end

		local function vector_concat_mode(vec1,vec2,mode1,mode2)--按照模式连接边集合
			local str={}
			local v1,vt=table.copy_deep(vec1[mode1]),(mode1~=mode2 and vector_reverse(table.copy_deep(vec2[mode2])) or table.copy_deep(vec2[mode2]))
			local v2=vector_same_start(v1,vt)
			v1,v2=vector_add_boolean(v1),vector_add_boolean(v2)
			local k=0
			repeat
				local sx,sy,ex,ey=0,0,0,0
				str[#str+1]=""
				for i=1,#v1+#v2--确定起始边
					do
					local vec_t=table.copy_deep((i%2==1 and v2[math.fmod((i+1)/2-1,#v2)+1] or v1[math.fmod(i/2-1,#v1)+1]))
					local str_t=vec_t.str
					local bool=vec_t.connect
					if bool
						then
						str[#str]=str[#str]..str_t--起始边
						sx=vec_t.sx--起始点x
						sy=vec_t.sy--起始点y
						ex=vec_t.ex--结束点x
						ey=vec_t.ey--结束点y
						if i%2==1
							then
							v2[(i+1)/2].connect=false
						else
							v1[i/2].connect=false
						end
						break
					end
				end

				for i=1,(intersect_n==0 and 2 or intersect_n/2)*(#v1+#v2)
					do
					local ir=math.fmod(i-1,#v1+#v2)+1
					local vec_t=table.copy_deep((ir%2==1 and v2[math.fmod((ir+1)/2-1,#v2)+1] or v1[math.fmod(ir/2-1,#v1)+1]))
					local str_t=vec_t.str
					local bool=vec_t.connect
					local sx1=vec_t.sx
					local sy1=vec_t.sy
					local ex1=vec_t.ex--结束点x
					local ey1=vec_t.ey
					if (bool and (sx1==ex and sy1==ey))
						then
						str[#str]=str[#str]..str_t
						ex=ex1
						ey=ey1
						if ir%2==1
							then
							v2[(ir+1)/2].connect=false
						else
							v1[ir/2].connect=false
						end
					end
				end
			until (vector_empty_check(v1)==false or vector_empty_check(v2)==false)
			return table.concat(vector_to_polygon(str))
		end

		local function vector_concat_mode_subtract(vec1,vec2,mode1,mode2)--按照模式连接边集合
			local str={}
			local v1,vt=table.copy_deep(vec1[mode1]),table.copy_deep(vec2[mode2])
			local v2=vector_same_start(v1,vt)
			v1,v2=vector_add_boolean(v1),vector_add_boolean(v2)
			local k=0
			repeat
				local sx,sy,ex,ey=0,0,0,0
				str[#str+1]=""
				for i=1,#v1+#v2--确定起始边
					do
					local vec_t=table.copy_deep((i%2==1 and v2[math.fmod((i+1)/2-1,#v2)+1] or v1[math.fmod(i/2-1,#v1)+1]))
					local str_t=vec_t.str
					local bool=vec_t.connect
					if bool
						then
						str[#str]=str[#str]..str_t--起始边
						sx=vec_t.sx--起始点x
						sy=vec_t.sy--起始点y
						ex=vec_t.ex--结束点x
						ey=vec_t.ey--结束点y
						if i%2==1
							then
							v2[math.fmod((i+1)/2-1,#v2)+1].connect=false
						else
							v1[math.fmod(i/2-1,#v1)+1].connect=false
						end
						break
					end
				end

				for i=1,(intersect_n==0 and 2 or intersect_n/2)*(#v1+#v2)
					do
					local ir=math.fmod(i-1,#v1+#v2)+1
					local vec_t=table.copy_deep((ir%2==1 and v2[math.fmod((ir+1)/2-1,#v2)+1] or v1[math.fmod(ir/2-1,#v1)+1]))
					local str_t=vec_t.str
					local bool=vec_t.connect
					local sx1=vec_t.sx
					local sy1=vec_t.sy
					local ex1=vec_t.ex--结束点x
					local ey1=vec_t.ey
					if (bool and (sx1==ex and sy1==ey))
						then
						str[#str]=str[#str]..str_t
						ex=ex1
						ey=ey1
						if ir%2==1
							then
							v2[math.fmod((ir+1)/2-1,#v2)+1].connect=false
						else
							v1[math.fmod(ir/2-1,#v1)+1].connect=false
						end
					end
				end
			until (vector_empty_check(v1)==false or vector_empty_check(v2)==false)
			return table.concat(vector_to_polygon(str))
		end

		union=vector_concat_mode(new_vec1,new_vec2,"odd","odd")
		intersect=vector_concat_mode(new_vec1,new_vec2,"even","even")
		sub1=vector_concat_mode(new_vec1,new_vec2,"odd","even")
		sub2=vector_concat_mode(new_vec2,new_vec1,"odd","even")
		return vec1,vec2,{union,intersect,sub1,sub2,sub1..shape.reverse(sub2)}
	end
end



