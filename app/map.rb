class Map
    attr_accessor :map_w, :map_h, :map_translation, :tile_w, :tile_h, :zoom_percent, :zoom_max, :tiles,
        :auxiliary_maps, :levels, :updated_tiles, :gen_complete


    def initialize(
        map_w: 10, map_h: 10, map_d: 2, map_translation: {:x => 0, :y => 0}, tile_w: 16, tile_h: 16, tile_d: 16,
        auxiliary_maps: {}, window: {:w => 1280, :h => 740}
    )
        @map_w = map_w
        @map_h = map_h
        @map_d = map_d
        @map_translation = map_translation
        @window = window
        @zoom = 1
        @tile_w = tile_w
        @tile_h = tile_h
        @tile_d = tile_h
        @tiles = {}
        @filled = {}
        @auxiliary_maps = auxiliary_maps
        @levels = (0..map_d).to_a()

        @chunk_w = 64 
        @chunk_h = 64 
        @gen_complete = false
        @last_key = [0, 0, 0]
        @updated_tiles = false
        @renders = []
    end


    def build_map_bases_level(base_tile, bases_z)
        @updated_tiles = true
        @tiles = {}
        @auxiliary_maps.actors_map = {} 
        @auxiliary_maps.waypoints = {}
        key = [
            0, 
            0, 
            0 
        ]

        @map_w.times do |w|
            @map_h.times do |h|
                @map_d.times do |d|
                    key = [
                        w, 
                        h, 
                        d 
                    ]

                    @tiles[key] = Tile.new(
                        :x => (key[0] * @tile_w),
                        :y => (key[1] * @tile_h),
                        :z => (key[2] * @tile_d),
                        :w => @tile_w,
                        :h => @tile_h,
                        :d => @tile_d,
                        :key => key
                    )

#                    @auxiliary_maps.actors_map[key] = nil
#                    @auxiliary_maps.waypoints[key] = nil
                end
            end
        end

        @gen_complete = true
    end


    def build_map_bases_level_02(base_tile, bases_z)
        @updated_tiles = true
        @tiles = []
        @auxiliary_maps.actors_map = [] 
        @auxiliary_maps.waypoints = []

        @map_w.times do |w|
            @tiles[w] = []
#            @auxiliary_maps.actors_map[key] = nil
#            @auxiliary_maps.waypoints[key] = nil
            @map_h.times do |h|
                @map_d.times do |d|
                    key = [
                        w, 
                        h, 
                        d 
                    ]

                    @tiles[w][h] = Tile.new(
                        :x => (key[0] * @tile_w),
                        :y => (key[1] * @tile_h),
                        :z => (key[2] * @tile_d),
                        :w => @tile_w,
                        :h => @tile_h,
                        :d => @tile_d,
                        :key => key
                    )
                    @tiles[w][h].generate_path()

#                    @auxiliary_maps.actors_map[key] = nil
#                    @auxiliary_maps.waypoints[key] = nil
                end
            end
        end

        @gen_complete = true
    end


    def update_filled(key: [0,0,0], is_filled: false, domain: {})
        @tiles[key[0]][key[1]].filled(is_filled: is_filled, domain: self)
        puts "-->#{@tiles[key[0]][key[1]]}<--"
        @tiles[key[0]][key[1]].generate_path()
        @updated_tiles = true
    end


    def render(level, geometry, grid)
        render_list = []
        start_render_tile = get_key(@map_translation)
        camera = get_key({:x => @window.w, :y => @window.h})
       
        (camera[0]).times do |w|
            (camera[1]).times do |h|
                x = start_render_tile.x + w
                y = start_render_tile.y + h

                if(@tiles.size > x && @tiles[x].size > y)
                    render_list << @tiles[x][y].render(@map_translation)
                end
            end
        end

        render_list
    end


    def remove_translation(obj)
        new_obj = obj.dup()
        new_obj.x -= @map_translation.x
        new_obj.y -= @map_translation.y

        return new_obj
    end


    def add_translation(obj)
        new_obj = obj.dup()
        new_obj.x += @map_translation.x
        new_obj.y += @map_translation.y

        return new_obj
    end


    def get_key(input)
        return [
            (input.x / @tile_w).floor,
            (input.y / @tile_h).floor
        ]
    end


    def has_key?(key)
        return (@tiles.size > key[0] && @tiles[key[0]].size > key[1]) 
    end


    def [](key)
        tile = nil

        if(has_key?(key))
            tile = @tiles[key[0]][key[1]]
        end

        return tile
    end


    def []=(key, value)
        if(!has_key?(key))
            return nil
        end

        @updated_tiles = true
        @tiles[key[0]][key[1]] = value
    end


    def delete_tile(key)
        if(!has_key?(key))
            return
        end

        @tiles.delete(key)
    end


    def values()
        @updated_tiles = false
        return @tiles.values()
    end
end