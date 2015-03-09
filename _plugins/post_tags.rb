module Jekyll
	module CustomTagFilter
		def post_tags(array)
			case array.length
			when 0
				""
			when 1
				array[0].to_s
			else
				"#{array.join(', ')}"
			end
		end
	end
end

Liquid::Template::register_filter(Jekyll::CustomTagFilter);