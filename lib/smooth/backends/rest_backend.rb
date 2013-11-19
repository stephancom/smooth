class Smooth::RestBackend < Smooth::Backend
  attr_accessor :client

  def initialize(options={})
    super
  end
end
