class Spawner < Structure 
    attr_accessor :spawnables


    def initialize(spawnables: [], spawn_rate: 10, capacity: 4, **args)
        super

        @spawnables = spawnables
        @spawn_rate = spawn_rate
        @capacity = capacity
        @path = @i_path
        @owned = []
    end


    def spawn(ticks)
        spawned = nil

        if(ticks % (@spawn_rate * 60) && @capacity > @owned.size())
            spawned = Actor.new(@spawnables.sample())
            @owned << spawned.id

            spawned.key = @key
            spawned.x = spawned.get_x() 
            spawned.y = spawned.get_y() 
            spawned.home = @id 
            spawned.align_on_tile()
        end

        return spawned
    end


    def remove_spawned(owned_id)
        @owned.delete_if{|elem| elem == owned_id}
    end
    

    def _tick(args)
        spawn(args.inputs.tick_count)
    end
end