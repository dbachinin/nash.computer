module DownloadHelper
	def check_token(line)
		t_size = Time.now.to_i.to_s(16).length
		st0 = Base64.decode64(line.reverse)

		i = 0

		arrbytes = []
		count = []
		st0.each_byte{|i| count << i; break if i == 10 }
		st0.each_byte{|i| arrbytes << (i) }
		  
		bytes = arrbytes[0..(count.count - 2)]
		id = arrbytes[(count.count)..-1]

		odd = []
		even = []
		data = bytes.pack('C*').scan(/../)

		data.each_with_index do |v, i|
		  if i.odd?
		    odd.push(v)
		  else
		    even.push(v)
		  end
		end
		symb = even.join.reverse.to_i(16).to_s(16)
		st1 = odd.join[1..-1].scan(/../).map { |i| i.to_i(16) - symb[0].to_i(16) }
		st2 = st1.map { |i| i.chr }.join
		if t_size > st2.length
		  st2 = st2 + ("0" * (t_size - st2.length))
		end
		if Time.at(st2.to_i(16)).day == Time.now.day && Time.at(st2.to_i(16)).month == Time.now.month && Time.at(st2.to_i(16)).year == Time.now.year && License.where(id: id.map { |i| i.chr }.join).exists?
		  "#{id.map { |i| i.chr }.join} #{symb}"
		else
		  print "ERR"
		end
	end
end
