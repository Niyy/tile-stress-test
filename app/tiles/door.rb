class Door < Structure
    attr_accessor :is_open


    def initialize(is_open: true, **args)
        super

        @is_open = is_open 
        @rotations = [10, 5]
    end


    def check_tile_valid(domain: domain)
        _is_north_filled = is_north_filled(domain) * 8
        _is_south_filled = is_south_filled(domain) * 2
        _is_east_filled = is_east_filled(domain) * 4
        _is_west_filled = is_west_filled(domain) * 1

        sum = _is_north_filled + _is_south_filled + _is_east_filled + _is_west_filled

        if( (_is_north_filled + _is_south_filled !=  10 && _is_east_filled + _is_west_filled != 5) ||
            (sum != 0)
        )
            return false
        end

        return true
    end


    def set_tile_index(domain: domain)
        @tile_index = @rotations[@rotation_index] & @_filled
    end


    def allow_passage(unit)
        # note team 0 is null
        return @is_open && super 
    end
end