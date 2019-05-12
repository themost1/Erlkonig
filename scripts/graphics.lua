local P = {}


function P.createShader()
	myShader = love.graphics.newShader[[
		
		extern number light;

		vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
		  	vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
		  	
		  	for (int i = 0; i < 3; ++i) {
		  		pixel[i] *= light;
		  	}

			return pixel;
		}
	]]
end

return P