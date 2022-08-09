class Structure < Tile
    attr_accessor


    def initialize(health: 1, required_inputs: {}, pierce_value: 1, traversable: false,
        built: false, passable: false, facing: [0, 0], material: '', structure_type: '', 
        domain: {}, rotations: [], rotation_index: 0, **args
    )
        super

        # Build variables
        @required_inputs = required_inputs # resource/item - amount
        @built = built
        @init_health = health
        @health = health if(built) else 0
        @pierce_value = pierce_value
        @traversable = traversable
        @facing = facing
        @material = material
        @structure_type = structure_type
        @rotations = rotations
        @rotation_index = rotation_index
    end


    def _tick(args)
    end


    def generate_path()
        if(!super())
            return false 
        end

        @path = @i_path + 
            '/'

        if(@material != nil && @material != '')
            @path += @material + '/'
        end
        if(@structure_type != nil && @structure_type != '') 
            @path += @structure_type + '/'
        end

        @path += @header 

        if(@_module)
            @path += @dil + ("%05b" % @tile_index)
        end

        @path += '.png'
    end


    def rotate(domain: {})
        if(@rotations.size < 1)
            return
        end

        @rotation_index += 1

        if(@rotation_index >= @rotations.size)
            @rotation_index = 0
        end

        set_tile_index(domain: domain)
        generate_path()
    end


    def construct(value: 0)
        if(@built)
            return false
        end

        @health += value

        if(@health > @init_health)
            @health = @init_health
            @built = true
        end

        return true
    end


    def damage(value: 0)
        @health -= value

        if(@health <= 0)
            return true
        end

        return false
    end


    def supply_build(resource_type: '', supplied_amount: 0)
        if(@required_inputs.has_key?(resource_type))
            @required_inputs[resource_type] -= supplied_amount 

            if(@required_inputs[resource_type] <= 0)
                @required_inputs.delete(resource_type)
            end

            return true
        end

        return false
    end


    def allow_passage(unit)
        is_north_south_passable = @rotations[@rotation_index] == @tile_index
        is_east_west_passable = @rotations[@rotation_index] == @tile_index

        # note team 0 is null
        return (is_north_south_passable || is_east_west_passable) && super 
    end


    def serialize()
        super().merge!({structure_type: @structure_type, 
            i_path: @i_path, header: @header, _filled: @_filled,
            material: @material, rotation_index: @rotation_index,
            rotations: @rotations
        })
    end
end