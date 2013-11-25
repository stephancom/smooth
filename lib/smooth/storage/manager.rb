module Smooth
  class Storage
    # The `Smooth::Storage::Manager` is responsible
    # for managing a separate thread, which handles
    # persisting and restoring storage instances on the
    # file system, or over the network.
    class Manager
      include Singleton

      attr_accessor :storage_instances

      def register storage_instance
        self.storage_instances ||= {}
        self.storage_instances[storage_instance.key] = storage_instance
      end

      def find key
        self.storage_instances.try(:[], key)
      end
    end
  end
end
