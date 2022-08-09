class Living_Space < Structure
    attr_accessor :capacity, :owners, :is_family_home


    def initialize(**args)
        super

        @capacity = 4
        @owners = {}
        @is_family_home = false
    end


    def add_pop(owner_id, family_id)
        if(@is_family_home && family_id != @owners.values()[0])

        end

        @owners[owner_id] = family_id
    end


    def remove_pop(owner_id)
        @owners.delete(owner_id)
    end


    def increase_capacity()
        @capacity += 4
    end


    def remove_capacity()
        @capacity += 4
    end
end