require 'net/http'
require 'json'
require 'date'

class Tweet
	include Enumerable

	attr_accessor :_status, :items
	attr_reader :_headers

	def initialize
		uri = URI('http://tweeps.locaweb.com.br/tweeps')
		req = Net::HTTP::Get.new(uri)
		req['Username'] = ENV['HTTP_USERNAME'] || 'leo.spaula@gmail.com'
		res = Net::HTTP.start(uri.hostname, uri.port) {|http|
		  http.request(req)
		}
		@_status  = res.code
    @_headers = res.to_hash.inspect
    @items = []
    build_items(res.body)
    sort_items
    self
	end

	def self.all
		new		
	end

	def to_a
    @items
  end

  def index(value)
    @items.index(value)
  end

  def each
    @items.each do |el|
      yield el
    end
  end

  def last
    @items.last
  end

  def first
    @items.first
  end

  def where(criteria={})
    @items.select do |object|
      select = true
      criteria.each do |k, v|
        if v.is_a?(Regexp)
          select = false if !object[k][v]
        else
          select = false if object[k] != v
        end
      end
      select
    end
  end


	private

	def build_items(response)
		json_response = JSON.parse(response, symbolize_names: true)

		json_response[:statuses].each do |res|
			unless res[:entities][:user_mentions].empty?
				if res[:entities][:user_mentions][0][:screen_name] == "locaweb" && !(res[:in_reply_to_user_id] == 42)
					@items << { followers_count: res[:user][:followers_count], screen_name: res[:user][:screen_name],
											profile_link: "https://twitter.com/#{res[:user][:screen_name]}", created_at: DateTime.parse(res[:created_at]),
											link: "https://twitter.com/#{res[:user][:screen_name]}/status/#{res[:id_str]}",
											retweet_count: res[:retweet_count], text: res[:text], favorite_count: res[:favorite_count] }
				end
			end
		end
	end

	def sort_items
		@items.sort_by!{|h| h[:followers_count]}.sort_by!{|h| h[:retweet_count]}.sort_by!{|h| h[:favorite_count]}
	end
end