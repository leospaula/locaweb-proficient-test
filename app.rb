require './simple_web_app'
require './lib/*.rb'

get '/most_relevants' do
	tw = Tweet.all
	tw.items.to_json
end

get '/most_mentions' do
	tw = Tweet.all
	MostMentionService.call(tw.items)
end

Rack::Handler::WEBrick.run SimpleWebApp::Application, Port: 9292