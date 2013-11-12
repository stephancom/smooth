class Smooth::Backend
  attr_accessor :id_sequence

  NotFound = Class.new(Exception)

  protected
    def all
      []
    end

    def method_missing meth, *args, &blk
      if %w{each map select reject inject detect collect}.include? meth.to_s
        if all && all.respond_to?(meth)
          return all.send(meth,*args,&blk)
        end
      end

      super
    end

    def id_sequence
      @id_sequence ||= 0
    end

    def timestamp_update_of(object={})
      object[:updated_at] = Time.now
      object
    end

    def timestamp_creation_of(object={})
      now = Time.now

      object[:created_at] ||= now
      object[:updated_at] = now
      object
    end

    def assign_id_to(object)
      object[:id] ||= self.id_sequence += 1
      object[:id]
    end
end
