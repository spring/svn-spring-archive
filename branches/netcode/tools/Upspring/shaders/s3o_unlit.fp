!!ARBfp1.0

TEMP texture0, texture1, normal, color, illum, reflect;

TEX texture0, fragment.texcoord[0], texture[0], 2D;
TEX texture1, fragment.texcoord[0], texture[1], 2D;

DP3 normal.w, fragment.texcoord[1], fragment.texcoord[1];
RSQ normal.w, normal.w;
MUL normal, fragment.texcoord[1], normal.w;

LRP color, texture0.a, program.local[0], texture0;
TEX reflect, normal, texture[2], CUBE;
LRP result.color, texture1.g, reflect, color;

END
