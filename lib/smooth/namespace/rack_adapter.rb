class Smooth::Namespace::RackAdapter
  attr_accessor :app, :options

  def initialize(app, options={})
    @app = app
    @options = options
  end

  def call(env)
    app.call(env)
  end
end
