local ShaderVertex = [[
	#pragma language glsl4
	varying vec4 VarScreenPosition;
	varying vec2 VarVertexCoord;

	void vertexmain()
	{
		VarVertexCoord = vec2(
			(love_VertexID << 1) & 2,
			love_VertexID & 2
		);

		VarScreenPosition = vec4(
			VarVertexCoord.xy * vec2(2.0, -2.0) + vec2(-1.0, 1.0),
			0,
			1
		);

		gl_Position = VarScreenPosition;
	}
]]

local ShaderFragment = [[
	#pragma language glsl4
	varying vec2 VarVertexCoord;

	uniform float Swizzle;

	out vec4 FragColor;
	void pixelmain()
	{
		vec2 UV = VarVertexCoord.xy;

		vec4 Output = vec4(
			UV.x,
			UV.y,
			1.0 - UV.y,
			1.0
		);

		if( Swizzle > 0.0 )
		{
			Output = Output.abgr;
		}

		FragColor = Output;
	}
]]

function love.load( Args )
	Shader = love.graphics.newShader(
		ShaderFragment,
		ShaderVertex
	)

	Canvas = love.graphics.newCanvas(
		512, 512,
		{
			type 		= "2d",
			format 		= "rgba16f",
			mipmaps 	= "none"
		}
	)

	----------------------------------
	-- Render default version
	----------------------------------
	love.graphics.setShader( Shader )
	love.graphics.setBlendMode( "none" )

	love.graphics.setCanvas( Canvas )
	Shader:send( "Swizzle", 0.0 )
	love.graphics.drawFromShader( "triangles", 3, 1 )
	love.graphics.setCanvas()

	local Data = love.graphics.readbackTexture( Canvas )

	local File = love.filesystem.newFile( "output_default.exr" )
	File:open( 'w' )
	File:write( Data:encode("exr") )
	File:close()

	----------------------------------
	-- Render swizzled version
	----------------------------------
	love.graphics.setCanvas( Canvas )
	Shader:send( "Swizzle", 1.0 )
	love.graphics.drawFromShader( "triangles", 3, 1 )
	love.graphics.setCanvas()

	Data = love.graphics.readbackTexture( Canvas )

	File = love.filesystem.newFile( "output_swizzled.exr" )
	File:open( 'w' )
	File:write( Data:encode("exr") )
	File:close()

	love.event.quit( 0 )
end