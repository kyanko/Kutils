Kfunc = require "Kfunc"
---------------------复数运算---------------
Kcomplex={
conju=comp_conju,
length=comp_length,
arg=comp_arg,
add=comp_add,
sub=comp_sub,
multi=comp_multi,
div=comp_div,
exp=comp_exp,
sin=comp_sin,
cos=comp_cos,
tan=comp_tan,
cot=comp_cot,
pow=comp_pow,
polar_to_xy=comp_polar_to_xy,
xy_to_polar=comp_xy_to_polar,
DFT=DFT
}

Kframe={
fad=frame_fad,
t=frame_t,
autotag=frame_autotag
}

---------------------颜色相关---------------
Kcolor={
get_RGB=get_RGB,
get_HSV=get_HSV,
get_HSL=get_HSL,
RGB_to_HSV=RGB_to_HSV,
RGB_to_HSL=RGB_to_HSL,
HSV_to_RGB=HSV_to_RGB1,
HSL_to_RGB=HSL_to_RGB1,
HSV_to_HSL=HSV_to_HSL,
HSL_to_HSV=HSL_to_HSV,
tag=color_tag,
gradient=color_gradient,
percent=color_percent
}

---------------------透明度相关---------------
Kalpha={
get_alpha=get_alpha,
tag=alpha_tag,
add=alpha_add,
sub=alpha_sub,
min=alpha_min,
max=alpha_max,
gradient=interpolate_alpha1
}

------------------贝塞尔曲线相关--------------------------
Kbezier={
coe=bezier_coe,
position=bezier_position,
length=bezier_n_length,
split=bezier_split,
uniform_speed=bezier_n_uniform_speed
}

Kmatrix={
add=matrix_add,
sub=matrix_sub,
transposition=matrix_transposition,
multi_number=matrix_multi_number,
multi_matrix=matrix_multi_matrix,
adjoint=matrix_adjoint,
inverse=matrix_inverse,
value=deter_value
}

math.num=num
math.length=math.distance1
math.tobinary=tobinary
math.permu=permu
math.combin=combin

---------------------三维投影---------------
KTDS=TDS

---------------------逻辑函数---------------
Klogic=logic

Kshape.move=Kshape.move
Kshape.scale=Kshape.scale
Kshape.rotate=Kshape.rotate
Kshape.shear=Kshape.shear
Kshape.rect=Kshape.rect
Kshape.triangle=Kshape.triangle
Kshape.round=shape.round
Kshape.half_round=shape.half_round
Kshape.arc=shape.arc
Kshape.ellipse_arc=shape.ellipse_arc
Kshape.arc_ring=shape.arc_ring
Kshape.ellipse_arc_ring=shape.ellipse_arc_ring
Kshape.sector=shape.sector
Kshape.ellipse_sector=shape.ellipse_sector
Kshape.screw=shape.screw
Kshape.positive_edge=shape.positive_edge
Kshape.positive_ring=shape.positive_ring
Kshape.positive_arc=shape.positive_arc
Kshape.star=shape.positive_edge_dou
Kshape.star_ring=shape.star_ring
Kshape.star_arc=shape.star_arc
Kshape.fillet_star=shape.fillet_star
Kshape.flower=shape.flower
Kshape.flower_arc=shape.flower_arc
Kshape.filter=shape.filter
Kshape.intergration=shape.intergration
Kshape.close=shape.close
Kshape.open=shape.open
Kshape.reverse=shape.reverse
Kshape.simplify=shape.simplify
Kshape.flat=shape.flat
Kshape.curvi=shape.curvi
Kshape.split=Kshape.split
Kshape.tosame=shape.tosame
Kshape.measure=shape.measure
Kshape.measure_text=shape.measure_text
Kshape.len=shape.len
Kshape.bounding_real=shape.bounding_real
Kshape.get_pos=get_pos
Kshape.concavity=shape.concavity
Kshape.get_point=shape.get_point
Kshape.point_in_shape=points_in_shape
Kshape.point_inside_shape=points_inside_shape
Kshape.transform=shape.transform
Kshape.polygon_to_fillet=shape.polygon_to_fillet

