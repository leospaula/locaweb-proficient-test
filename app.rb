require './simple_web_app'
require './lib/tweet'
require './lib/most_mention_service'

get '/most_relevants' do
	tw = Tweet.all
	tw.items.to_json
end

get '/most_mentions' do
	tw = Tweet.all
	MostMentionService.call(tw.items)
end

Rack::Handler::WEBrick.run SimpleWebApp::Application, Port: 9292 unless ENV['RACK_ENV'] == 'test'