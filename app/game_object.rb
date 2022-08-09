class Game_Object
    attr_sprite
    attr_accessor :id, :key, :z, :i_path, :header, :dil

    @@id_counter = 0
    @@_tile_w = 16
    @@_tile_h = 16

    def initialize(x: 0, y: 0, z: 0, w: 8, h: 8, i_path: 'sprites/tile', header: 'wall', dil: '-', key: [0, 0],
        max_store: 10, type: :none, **args
    )
        @x = x
        @y = y
        @z = z
        @w = w
        @h = h
        @header = header
        @dil = dil
        @i_path = i_path
        @key = key
        @id = @@id_counter
        @store = {}
        @max_store = 10
        @current_store = 0
        @type = type

        @@id_counter += 1
    end


    def reset()
        @x = @key[0] * w
        @y = @key[1] * h
    end


    def update_key(key)
        @key = key

        @x = get_x()
        @y = get_y()
    end


    def increase_stock(type, amount)
        overfill = 0
        @current_store = @current_store + amount

        if(@current_store > @max_store)
            overfill = @current_store - @max_store
            @current_store = @max_store
        end

        return overfill
    end


    def decrease_stock(type, amount)
        negative_removal = 0
        @current_store = @current_store - amount

        if(@current_store > 0)
            negative_removal = @current_store.abs
            @current_store = 0 
        end

        return negative_removal 
    end


    def render(offset)
        return {
            x: @x + offset.x,
            y: @y + offset.y,
            w: @w,
            h: @h,
            path: @path
        }
    end


    def self.set_tile_w(w)
        @@_tile_w = w
    end


    def self.set_tile_h(h)
        @@_tile_h = h
    end


    def self.get_tile_w()
        @@_tile_w
    end


    def self.get_tile_h()
        @@_tile_h
    end


    def north target_domain
        key = [
            @key[0],
            @key[1] + 1,
            @key[2]
        ]

        if !(target_domain.has_key? key)
            return []
        end

        return key 
    end


    def is_north_filled domain
        key = [
            @key[0],
            @key[1] + 1,
            @key[2]
        ]

        if(!(domain.has_key?(key)) || domain[key]._filled != 0)
            return 0 
        else
            return 1
        end
    end


    def north_west target_domain
        key = [
            @key[0] - 1,
            @key[1] + 1,
            @key[2]
        ]

        if !(target_domain.has_key? key)
            return []
        end

        return key
    end


    def west target_domain
        key = [
            @key[0] - 1,
            @key[1],
            @key[2]
        ]

        if !(target_domain.has_key? key)
            return []
        end

        return key
    end


    def is_west_filled domain
        key = [
            @key[0] - 1,
            @key[1],
            @key[2]
        ]

        if(!(domain.has_key? key) || domain[key]._filled != 0)
            return 0 
        else
            return 1
        end
    end


    def south_west target_domain
        key = [
            @key[0] - 1,
            @key[1] - 1,
            @key[2]
        ]

        if !(target_domain.has_key? key)
            return []
        end

        return key
    end


    def south target_domain
        key = [
            @key[0],
            @key[1] - 1,
            @key[2]
        ]

        if !(target_domain.has_key? key)
            return []
        end

        return key
    end


    def is_south_filled domain
        key = [
            @key[0],
            @key[1] - 1,
            @key[2]
        ]

        if(!(domain.has_key? key) || domain[key]._filled != 0)
            return 0 
        else
            return 1
        end
    end


    def south_east target_domain
        key = [
            @key[0] + 1,
            @key[1] - 1,
            @key[2]
        ]

        if !(target_domain.has_key? key)
            return []
        end

        return key
    end


    def east target_domain
        key = [
            @key[0] + 1,
            @key[1],
            @key[2]
        ]

        if !(target_domain.has_key? key)
            return []
        end

        return key
    end


    def is_east_filled domain
        key = [
            @key[0] + 1,
            @key[1],
            @key[2]
        ]

        if(!(domain.has_key? key) || domain[key]._filled != 0)
            return 0 
        else
            return 1
        end
    end


    def north_east target_domain
        key = [
            @key[0] + 1,
            @key[1] + 1,
            @key[2]
        ]

        if !(target_domain.has_key? key)
            return []
        end

        return key
    end


    def north_from key, target_domain
        new_key = [
            key[0],
            key[1] + 1,
            key[2]
        ]

        if(!target_domain.has_key?(new_key) || (target_domain.has_key?(new_key) && !target_domain[new_key].nil? 
            target_domain[new_key].class == Tile && target_domain[new_key]._filled != 0
        ))
            return []
        end

        return new_key
    end


    def north_west_from key, target_domain
        new_key = [
            key[0] - 1,
            key[1] + 1,
            key[2]
        ]


        if(!target_domain.has_key?(new_key) || (target_domain.has_key?(new_key) && !target_domain[new_key].nil? &&
            target_domain[new_key].class == Tile && target_domain[new_key]._filled != 0
        ))
            return []
        end

        return new_key
    end


    def west_from key, target_domain
        new_key = [
            key[0] - 1,
            key[1],
            key[2]
        ]

        if(!target_domain.has_key?(new_key) || (target_domain.has_key?(new_key) && !target_domain[new_key].nil? &&
            target_domain[new_key].class == Tile && target_domain[new_key]._filled != 0
        ))
            return []
        end

        return new_key
    end


    def south_west_from key, target_domain
        new_key = [
            key[0] - 1,
            key[1] - 1,
            key[2]
        ]


        if(!target_domain.has_key?(new_key) || (target_domain.has_key?(new_key) && !target_domain[new_key].nil? &&
            target_domain[new_key].class == Tile && target_domain[new_key]._filled != 0
        ))
            return []
        end

        return new_key
    end


    def south_from key, target_domain
        new_key = [
            key[0],
            key[1] - 1,
            key[2]
        ]


        if(!target_domain.has_key?(new_key) || (target_domain.has_key?(new_key) && !target_domain[new_key].nil? && 
            target_domain[new_key].class == Tile && target_domain[new_key]._filled != 0
        ))
            return []
        end

        return new_key
    end


    def south_east_from key, target_domain
        new_key = [
            key[0] + 1,
            key[1] - 1,
            key[2]
        ]

        if(!target_domain.has_key?(new_key) || (target_domain.has_key?(new_key) && !target_domain[new_key].nil? &&
            target_domain[new_key].class == Tile && target_domain[new_key]._filled != 0
        ))
            return []
        end

        return new_key
    end


    def east_from key, target_domain
        new_key = [
            key[0] + 1,
            key[1],
            key[2]
        ]

        if(!target_domain.has_key?(new_key) || (target_domain.has_key?(new_key) && !target_domain[new_key].nil? &&
            target_domain[new_key].class == Tile && target_domain[new_key]._filled != 0
        ))
            return []
        end

        return new_key
    end


    def north_east_from key, target_domain
        new_key = [
            key[0] + 1,
            key[1] + 1,
            key[2]
        ]

        if(!target_domain.has_key?(new_key) || (target_domain.has_key?(new_key) && !target_domain[new_key].nil? && 
            target_domain[new_key]._filled != 0
        ))
            return []
        end

        return new_key
    end


    def calc_dist(compare_val)
        out_x = @key[0] - compare_val[0]
        out_y = @key[1] - compare_val[1]

        dist = out_x*out_x + out_y*out_y
       
        return dist
    end


    def calc_mag(compare_val)
        dist = calc_dist(compare_val)

        return Math.sqrt(dist)
    end


    def calc_dist_from(start_p, end_p = [0, 0])
        out_x = start_p[0] - end_p[0]
        out_y = start_p[1] - end_p[1]

        dist = out_x*out_x + out_y*out_y
       
        return dist
    end


    def calc_mag_from(start_p, end_p = [0, 0])
        dist = calc_dist_from(start_p, end_p)

        return Math.sqrt(dist)
    end


    def get_x()
        return @key[0] * @@_tile_w
    end


    def get_y()
        return @key[1] * @@_tile_h
    end


    def get_z()
        return @key[2] * @@_tile_d
    end


    def serialize
        { x: @x, y: @y, w: @w, h: @h, path: @path, header: @header, dil: @dil,
        type: @type, key: @key }
    end


    def to_s
        serialize.to_s
    end


    def inspect
        serialize.to_s
    end
end