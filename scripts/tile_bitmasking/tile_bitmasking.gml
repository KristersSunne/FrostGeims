function tile_bitmasking(xoffset,yoffset, tilemap){
/*
    Returns the tile index of the appropriate tile after checking tiles to the North, West, East, and South
*/

var index,north_tile,south_tile,west_tile,east_tile,size;

size = 1;

// Directional check
north_tile = tile_get(tilemap,xoffset,yoffset-size);
west_tile = tile_get(tilemap,xoffset-size,yoffset);
east_tile = tile_get(tilemap,xoffset+size,yoffset);
south_tile = tile_get(tilemap,xoffset,yoffset+size);


//perform 4 bit Bitmasking calculation
index =north_tile + 2*west_tile + 4*east_tile + 8*south_tile;

return index+4;
}

function tile_get(_tileset,_x,_y){
	var _tiledata = tilemap_get(_tileset,_x,_y);

	if(_tiledata = 3){
		return 0;
	} else if(_tiledata = 0){
		return 0;
	} else return true;

}