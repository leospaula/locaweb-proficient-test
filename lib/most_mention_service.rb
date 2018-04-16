class MostMentionService
	def initialize(items)
		@items = items
	end

	def self.call(*args)
		new(*args).call
	end

	def call
		return build_mentions(@items)
	end

	private

	def build_mentions(items)
		final_ar = Array.new
		users_list = Array.new
		items.each do |item|
			users_list << item[:screen_name]
		end
		users_list.uniq.each do |user|
			temp_ar = Array.new
			items.each do |item|
				temp_ar << item if user == item[:screen_name]
			end

			final_ar << { "#{user}": temp_ar }
		end

		return final_ar.to_json
	end
end