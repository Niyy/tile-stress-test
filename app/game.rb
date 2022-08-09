class Game
    attr_gtk
    attr_accessor :map, :actors_map, :actors, :cursor_tile, :mouse_pos, 
    :screen_pos, :ui, :font


    def _tick
        _outputs(outputs, state)
        _inputs(inputs, state)
        _logic(state)
    end


    def initialize args
        @font = "fonts/_bitmap_font____romulus_by_pix3m_d6aokem.ttf"
        @args = args
        @map = {}
        @map_transition = [0, 0]
        @tile_w = 32
        @tile_h = 32
        @cursor_tile = Structure.new(
            w: @tile_w, 
            h: @tile_h, 
            :health => 200,
            :required_inputs => :stone,
            :material => 'stone',
            :pierce_value => 2,
            :built => true,
            :is_filled => true,
            :type => :structure,
            :path => 'sprites/tile',
            :structure_type => 'wall',
            :header => 'structure-temp'
        )
        @cursor_tile.generate_path()
        Game_Object.set_tile_w(@tile_w)
        Game_Object.set_tile_h(@tile_h)
        @map = Map.new(
            map_w: 400,
            map_h: 400,
            map_d: 1,
            tile_w: 32, 
            tile_h: 32,
            tile_d: 32,
            auxiliary_maps: {actors_map: {}, waypoints: {}}
        )
        @map.build_map_bases_level_02(
            Tile.new(w: @tile_w, h: @tile_h), 
            0
        )
        @current_level = 0
        
        ## Input ##
        @key_management = {}
        @key_management.click = {}
        @key_management.click.button_left = -1 
        @key_management.click.button_right = -1
        @key_management.click.r = -1
        @mouse_key = [0, 0]
        @mouse_pos = {:x => 0, :y => 0, w: 1, h: 1} 
        @screen_pos = {:x => 0.0, :y => 0.0, :w => 1, :h => 1} 

        ## UI ##
        @border_color = {r: 255, b: 255, g: 255}
    end


    def _inputs(inputs, state)
        @mouse_pos = @map.remove_translation(inputs.mouse)
        @screen_pos.x = inputs.mouse.x
        @screen_pos.y = inputs.mouse.y
        key = get_key(@mouse_pos)
        has_key = @map.has_key?(key)
        
        if(has_key)
            if( @cursor_tile.path != nil && @key_management.click.r == state.tick_count)
                @cursor_tile.rotate()
            end

#            puts "#{@cursor_tile.path} != nil && #{@key_management.click.button_left} == #{state.tick_count} &&
#                #{@map[key].check_tile_valid(domain: @map)}"

            if(@cursor_tile.path != nil && @key_management.click.button_left == state.tick_count &&
                @map[key].check_tile_valid(domain: @map)
            )
                @map[key] = generate_object(@cursor_tile.serialize())
                @map[key].place(key, @map)

                @last_placed_tile = @map[key]
            end
            if(@key_management.click.button_right == state.tick_count)
                @map[key] = Tile.new(@cursor_tile.serialize())
                @map[key].update_key(key)
                @map.update_filled(key: key, is_filled: false, domain: @map)
            end
            
            @cursor_tile.x = (key[0] * @tile_w) + @map.map_translation.x
            @cursor_tile.y = (key[1] * @tile_h) + @map.map_translation.y
        end

        if(inputs.mouse.button_left)
            @key_management.click.button_left = state.tick_count + 1
        end
        if(inputs.mouse.button_right)
            @key_management.click.button_right = state.tick_count + 1
        end
        if(inputs.keyboard.key_down.r)
            @key_management.click.r = state.tick_count + 1
        end
    end


    def _logic state
        updated_actors_on_map = {}
        updated_waypoints = {}

        @mouse_key = [
            inputs.mouse.x - @map.map_translation.x,
            inputs.mouse.y - @map.map_translation.y
        ]
    end


    def _outputs(outputs, state)
        renders = []

        outputs.sprites << [0, 0, grid.right, grid.top, 'sprites/tile/default.png']
        renders << @map.render(@current_level, geometry, grid)

        mouse_tile = get_key(@mouse_key)
        outputs.primitives << renders
        outputs.primitives << @cursor_tile
            .serialize()
            .merge!(@border_color)
            .border!()
        outputs.labels << { 
            x: grid.left, 
            y: grid.top-90, 
            text: "Key: #{mouse_tile}",
            font: @font
        }.merge!(@border_color)
        outputs.labels << { 
            x: grid.left, 
            y: grid.top-110, 
            text: "Screen Pos: #{@screen_pos}",
            font: @font
        }.merge!(@border_color)
    end


    def get_key input
        return [
            (input.x / @tile_w).floor,
            (input.y / @tile_h).floor,
            @current_level
        ]
    end


    def generate_object(structure)
        case(structure.type)
        when :structure
            return Structure.new(structure.merge!(w: @tile_w, h: @tile_h))
        when :door
            return Door.new(structure.merge!(w: @tile_w, h: @tile_h))
        end
    end


    def serialize()
        return {
            cursor_tile: @cursor_tile
        }
    end


    def to_s()
        serialize().to_s()
    end


    def inspect()
        serialize().to_s()
    end
end


def tick args
#    puts "start tick"
    args.gtk.log_level = :off
    $game = Game.new(args) if(args.state.tick_count == 0)

    $game.args = args

    $game._tick

    args.outputs.debug << args.gtk.framerate_diagnostics_primitives
#    puts "end tick"
end