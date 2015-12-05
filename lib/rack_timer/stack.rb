require 'active_support/core_ext/benchmark'

class ActionDispatch::MiddlewareStack
  # This class will wrap around each Rack-based middleware and take timing snapshots of how long
  # each middleware takes to execute
  class RackTimer

    LogThrehold = ENV.has_key?('RACK_TIMER_LOG_THRESHOLD') ? ENV['RACK_TIMER_LOG_THRESHOLD'].to_f : 0.0

    def initialize app
      @app = app
    end

    def call(env)
      status, headers, body = nil, nil, nil
      cost_ms = Benchmark.ms { status, headers, body = @app.call env }
      last_cost_ms = env['rack_timer.cost_ms']
      env['rack_timer.cost_ms'] = cost_ms
      unless last_cost_ms
        last_cost_ms = 0.0
        request = Rack::Request.new env
        Rails.logger.info "Rack Timer - #{request.request_method} #{request.url}"
      end
      if cost_ms - last_cost_ms > LogThrehold
        Rails.logger.info "Rack Timer - #{@app.class.name}: #{cost_ms} ms, +#{cost_ms - last_cost_ms} ms"
      end
      [status, headers, body]
    end
  end

  class Middleware
    # Overrding the built-in Middleware.build and adding a RackTimer wrapper class
    def build(app)
      RackTimer.new(klass.new(app, *args, &block))
    end
  end

  # overriding this in order to wrap the incoming app in a RackTimer, which gives us timing on the final
  # piece of Middleware, which for Rails is the routing plus the actual Application action
  def build(app = nil, &block)
    app ||= block
    raise "MiddlewareStack#build requires an app" unless app
    middlewares.reverse.inject(RackTimer.new(app)) { |a, e| e.build(a) }
  end
end
