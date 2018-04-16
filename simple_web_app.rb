require "rack"

module SimpleWebApp
  class Base
    def initialize
      @routes = {}
    end

    attr_reader :routes, :request

    def get(path, &handler)
      route("GET", path, &handler)
    end

    def call(env)
      @request = Rack::Request.new(env)
      verb = @request.request_method
      requested_path = @request.path_info

      handler = @routes[verb][requested_path]

      handler = @routes.fetch(verb, {}).fetch(requested_path, nil)

      if handler
        result = instance_eval(&handler)
        if result.class == String
          [200, { 'Content-Type' => 'application/json' }, [result]]
        else
          result
        end
      else
        [404, {}, ["Oops! No route for #{verb} #{requested_path}"]]
      end
    end

    private

    def route(verb, path, &handler)
      @routes[verb] ||= {}
      @routes[verb][path] = handler
    end

    def params
      @request.params
    end
  end

  Application = Base.new

  module Delegator
    def self.delegate(*methods, to:)
      Array(methods).each do |method_name|
        define_method(method_name) do |*args, &block|
          to.send(method_name, *args, &block)
        end

        private method_name
      end
    end

    delegate :get, :head, to: Application
  end
end

include SimpleWebApp::Delegator