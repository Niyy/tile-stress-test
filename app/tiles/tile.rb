class Tile < Game_Object
    attr_accessor :tile_index, :_filled, :items, :default


    def initialize(is_filled: false, _module: true, domain: {}, **arg)
        super

        set_is_filled(is_filled: is_filled)
        @tile_index = @_filled if(_module)
        @items = {}
        @default = 'sprites/tile/default.png'
        @_module = _module

#        set_tile_index(domain: domain)
#        generate_path()
    end


    def place(key, domain)
        @key = key

        reset()
        filled(is_filled: true, domain: domain)
        generate_path()
    end


    def check_tile_valid(domain: domain)
        return true
    end


    def set_tile_index(domain: domain)
        if(!@_module)
            return
        end

        @tile_index = (
            (is_north_filled(domain) * 8) + 
            (is_south_filled(domain) * 2) +
            (is_east_filled(domain) * 4) +
            (is_west_filled(domain) * 1)
        ) & @_filled
    end


    def generate_path()
        if(@_filled == 0)
            @path = @default 
            return false 
        end

        @path = @i_path + 
            '/' + 
            @header + 
            @dil 

        if(@_module)
            @path += ("%05b" % @tile_index)
        end

        @path += '.png'
    end


    def set_is_filled(is_filled: false)
        if is_filled
            @_filled = 15
        else
            @_filled = 0
        end       
    end


    def filled(is_filled: false, domain: {})
#        if(@_module)
#            return
#        end

        set_is_filled(is_filled: is_filled)
        set_tile_index(domain: domain)

        _north = north(domain)
        _south = south(domain)
        _west = west(domain)
        _east = east(domain)

        domain[_north].set_tile_index(domain: domain) if(!_north.empty?)
        domain[_north].generate_path() if(!_north.empty?)
        domain[_south].set_tile_index(domain: domain) if(!_south.empty?)
        domain[_south].generate_path() if(!_south.empty?)
        domain[_east].set_tile_index(domain: domain)  if(!_east.empty?)
        domain[_east].generate_path() if(!_east.empty?)
        domain[_west].set_tile_index(domain: domain)  if(!_west.empty?)
        domain[_west].generate_path() if(!_west.empty?)
    end


    def allow_passage(unit)
        # note team 0 is null
        return (unit.owner == @owner || @owner <= 0) && @_filled < 15
    end


    def render(offset)
#        generate_path()

        return super(offset)
    end
end