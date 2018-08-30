#!/bin/bash

echo "building 3D math"

rm build.wren

cat begin.wren  \
	Draw.wren   \
	Vector.wren \
	Matrix.wren \
	Box.wren    \
	Game.wren   \
	end.wren   >> build.wren