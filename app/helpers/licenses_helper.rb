module LicensesHelper

    require "openssl"
    require 'io/console'
    def create_license(id)
      LicenseCode.new(id).gen_license
    end
  class LicenseCode
      def initialize(id)
         @id, @encrypted = id, encrypted
     end
     attr_accessor :id, :encrypted
     #generate indexes
     #
        def vardata_generator
          out = []
          mixkey = []
          out2 = []
          
          while mixkey == out2
            mixkey = []
            
            4.times do
                v = rand(-16..15)
                val = "%04b" % [v].pack('L').unpack('L')
                mixkey << val.rjust(32,"0")
            end
            ciphermix = []
            
            mixkey.each do |item|
                st1 = []
                i = 0
                
                16.times do
                    dat = item.scan(/../)
                    st1.push(dat[i+1] + dat[i]) if i <= 15
                    i+=2
                end
                st2 = []
                i = 0
                
                8.times do
                    st2 << st1 [ i - 3 ]
                    i+=1
                end
                ciphermix.push(st2.join)
            end
            dat = (((Time.now.to_i / 86400) * 86400) - 1515616054).to_s(16)
            
            dat = dat.rjust(8,"0")
            regxp = "."

            arr = ciphermix[0].scan(/#{regxp}/).zip(ciphermix[1].scan(/#{regxp}/),ciphermix[2].scan(/#{regxp}/),ciphermix[3].scan(/#{regxp}/)).join.scan(/.../).map{|i|i.reverse}.join.to_i(2).to_s(16)[0..-9] + dat
            out << arr.scan(/..../)
            inv = out
            dat = Time.at(inv.join.downcase[-8..-1].to_i(16) * 86400 / 86400 + 1515616054)
            cipher = (inv.join.downcase[0..-9] + (inv.join.downcase[-11..-9] * 3)[0..-2]).to_i(16).to_s(2)
            cipher = "0"*(126 - cipher.to_s.length) + cipher
            out1 = [];s1 = [];4.times{|n|s1 << cipher.scan(/.../).map{|i|i.reverse}.join.scan(/..../).map{|i|i[n]}.join};out1 = s1.map{|i|i = i + i[-1]}
            out2 = [];out1.each{|item|v = [];v1 = [];v2 = [];i = -8; 8.times{v << item.scan(/..../)[i + 3];i+=1};v1 << v.join;v1.each{|i|dat = i.scan(/../);i = 0;16.times{v2 << dat[i + 1] + dat[i] if i <= 15;i+=2}};v2.join.length < 32 ? out2 << v2.join + "0" : out2 << v2.join}
            return [out2.map{|i|i[0..8].include?('00000') ? val = [i.to_i(2)].pack('c*').unpack('H*')[0].to_i(16) : val = [i.to_i(2)].pack('c*').unpack('H*')[0].to_i(16) - 16**2},inv]
          end
        end
     # def pack_data(key,data)
    def do_create_user(uname,pw)
        %x( sudo useradd -m -p #{ pw.crypt("$3$2$1") } #{ uname } ); p "useradd OK"
        %x( sudo [ ! `cut -d: -f1 /etc/group|grep sendfile` ] && addgroup sendfile ); p "addgroup OK"
        %x( sudo usermod -a -G sendfile uname );p "usermod OK"
        %x( sudo mkhomedir_helper uname ); p "mkhomedir OK"
        userhome = "/home/#{uname}"
        %x( sudo encode tmp/license_#{uname}_rev.key #{userhome}/key ); p "encode key OK"
        pwd = Dir.pwd
        Dir.chdr(userhome)
        %x( sudo su #{uname} -c "mkdir ssh;ssh-keygen -b 2048 -t rsa -f #{userhome}/ssh/sshkey -q -N \"\"" ); p "make keys OK"
        %x( encode #{userhome}/ssh/sshkey #{userhome}/key1 ); p "encode 1key"
        %x( cat #{userhome}/ssh/sshkey.pub > authorized_keys ); p "put pubkey to authorized_keys"
        %x( encode #{userhome}/ssh/sshkey.pub #{userhome}/key2 );p "encode key2 OK"
    end

     #  end
     #encode data with mix key by indexes
     def gen_license
        encrypted = false
        arr_in = []
        i=0
        check = false
        break_val = 0
        until check
          break_val+=1
          lic = License.find(@id).as_json(except: ["key", "licenses", "description", "licensefile"])
          key = @id.scan(/../).map {|i| i.hex.chr}.join.unpack("L>*")
          key.push(((Time.now.to_i / 86400) * 86400) - 1515616054).pack("N*").to_hex_string
          cipher = OpenSSL::Cipher::AES.new(128, :ECB)
          cipher.encrypt
          if i == 0
              lic.as_json.each{
                  |k,v| v = v["$oid"] if k == "_id"
                  v = v + "  " if k == "description"
                  arr_in.push("#{k}|#{v}\n")
              } 
          end
            arr_in[2] = arr_in[2][0..-2] + " " + arr_in[2][-2..-1]
          key = key.pack("N*")
          cipher.key = key
          encrypted = cipher.update(arr_in.join) + cipher.final
          i+=0
          secretkey = self.vardata_generator
          data = encrypted.unpack("N*")
          key = key.unpack("N*")
          i = 0
          vardata = secretkey[0]
          key.each{|item|val = vardata[i]; data.insert(val,item);i +=1}
          license = License.find(@id)
          tempFile = "tmp/license_#{@id.reverse[0..3]}test.lic"
          File.open(tempFile, 'wb' ){|f| f.write(data.pack("L*"))}
          # test = "./bin/decoder #{secretkey[1][0].map{|i|secretkey[1][0].last != i ? i + '-' : i}.join} \'tmp/license_#{@id.reverse[0..3]}test.lic\'"
          # test = test + "\n#{File.read(tempFile)}"
          # File.write('tmp/tmp', test)
          break if break_val == 10
          check = system( "decoder #{secretkey[1][0].map{|i|secretkey[1][0].last != i ? i + '-' : i}.join} \'tmp/license_#{@id.reverse[0..3]}test.lic\'" )
          FileUtils.rm("tmp/license_#{@id.reverse[0..3]}test.lic")
          # File.open("tmp/license_#{@id.reverse}.lic", 'wb' ){|f| f.write(data.pack("L*"))}
          license.licensefile = BSON::Binary.new(data.pack("L*"))
          license.save
        end
        keyout = secretkey[1][0].map{|i|secretkey[1][0].last != i ? i + '-' : i}.join
        # %x( encode #{keyout} "tmp/license_#{@id.reverse}.key" )
        # File.write("tmp/license_#{@id.reverse}.key", secretkey[1][0].map{|i|secretkey[1][0].last != i ? i + '-' : i}.join)
        return keyout
        
     end

     def gen_hash
        pos = rand(0..32)
        hexqud = @dat[pos..pos + 3]
        digit = hexqud.to_i(16).to_s(10)
        return @dat,digit
     end

     def check_hash(dec)
       if @dat.include?(dec.to_i(10).to_s(16))
         puts "OK"
       else
         puts "ERR"
       end
     end
 end
end
#convert unsignet binary to dec
# ciphermix.pack('L*').to_hex_string
#and
#mixkey.each{|i|i[0..8].include?('00') ? val = [i.to_i(2)].pack('c*').to_hex_string.to_i(16) : val = [i.to_i(2)].pack('c*').to_hex_string.to_i(16) - 16**2; p val}

#mix bytes (deprecated)
#st1 = [];i = 0;16.times{dat = item.scan(/../);st1.push(dat[i+1] + dat[i] + "   " + i.to_s) if i <= 15;i+=2};st2 = []; i = 0; 8.times{st2 << st1 [ i - 3 ]; i+=1}

#2 stage demix (deprecated)
#st1 = [];ciphermix.each{|item|v = [];i = -8; 8.times{v << item.scan(/..../)[i + 3];i+=1};st1 <<v.join}

#demix
#repair value
#o = [];(32 - item.length).times{o << "0"};item = o.join + item
#tmp = [];o = [];ciphermix.each{|item|item = item.to_s(2); (32 - item.length).times{o << "0"};tmp << o.join + item; o = []};ciphermix = tmp
#out1 = [];out2.each{|item|v = [];v1 = [];v2 = [];i = -8; 8.times{v << item.scan(/..../)[i + 3];i+=1};v1 << v.join;v1.each{|i|dat = i.scan(/../);i = 0;16.times{v2 << dat[i + 1] + dat[i] if i <= 15;i+=2}};out1 << v2.join}

#cipher
#ciphermix = [];mixkey.each{|item|st1 = [];i = 0;16.times{dat = item.scan(/../);st1.push(dat[i+1] + dat[i]) if i <= 15;i+=2};st2 = []; i = 0; 8.times{st2 << st1 [ i - 3 ]; i+=1};ciphermix.push(st2.join)}

#generate key
#mixkey = [];4.times{v = rand(0..32) - 16;val = "%04b" % [v].pack('L').unpack('L');val.length < 16 ? val = ("0000000000000000000000000000" + val.to_s) : val = val; mixkey << val}

#advanced mix
#@out = '';i = 0;@regxp = '';10.times{|x|i+=1;@f =  i;break if test.length.gcd(i) != 1};@f.times{@regxp = @regxp + '.'};start = (test.length / @f) / 2;i = 0;(test.length / @f).times{i+=1;i = i - start * 2 - 1 if (start + i) >= (test.length / @f) or start < (test.length / @f) / 2;@out = @out + test.scan(/#{@regxp}/)[start + i].reverse;}

#???
#key.each{|item|i +=1;vardata[i] == "-" ? val = ("-" + vardata[i+1]).to_i : val = vardata[i].to_i; data.insert(val,item)}




#ENCODE
# out = []
# mixkey = [];4.times{v = rand(-16..16);val = "%04b" % [v].pack('L').unpack('L');val.length < 16 ? val = ("0000000000000000000000000000" + val.to_s) : val = val; mixkey << val}
# ciphermix = [];mixkey.each{|item|st1 = [];i = 0;16.times{dat = item.scan(/../);st1.push(dat[i+1] + dat[i]) if i <= 15;i+=2};st2 = []; i = 0; 8.times{st2 << st1 [ i - 3 ]; i+=1};ciphermix.push(st2.join)}
# dat = (((Time.now.to_i / 86400) * 86400) - 1515616054).to_s(16);(8 - dat.length).times{dat = "0"+dat};regxp = ".";arr = ciphermix[0].scan(/#{regxp}/).zip(ciphermix[1].scan(/#{regxp}/),ciphermix[2].scan(/#{regxp}/),ciphermix[3].scan(/#{regxp}/)).join.scan(/.../).map{|i|i.reverse}.join.to_i(2).to_s(16)[0..-9] + dat
# out = arr.upcase.scan(/..../)
# 
#DECODE
#dat = Time.at(inv.join.downcase[-8..-1].to_i(16) * 86400 / 86400 + 1515616054)
#o = "";(128 - inv.join.downcase.to_i(16).to_s(2).length).times{o = "0" + o };cipher = o + (inv.join.downcase[0..-9] + (inv.join.downcase[-11..-9] * 3)[0..-2]).to_i(16).to_s(2)
#out = [];s1 = [];4.times{|n|s1 << cipher.scan(/.../).map{|i|i.reverse}.join.scan(/..../).map{|i|i[n]}.join};out = s1.map{|i|i = i + i[-1]}
#tmp = [];o = [];out.each{|item|(32 - item.length).times{o << "0"};tmp << o.join + item; o = []}
#out1 = [];out2.each{|item|v = [];v1 = [];v2 = [];i = -8; 8.times{v << item.scan(/..../)[i + 3];i+=1};v1 << v.join;v1.each{|i|dat = i.scan(/../);i = 0;16.times{v2 << dat[i + 1] + dat[i] if i <= 15;i+=2}};out1 << v2.join}
#out1.map{|i|i[0..8].include?('00000') ? val = [i.to_i(2)].pack('c*').to_hex_string.to_i(16) : val = [i.to_i(2)].pack('c*').to_hex_string.to_i(16) - 16**2}


# #simple crypt <-> decrypt
# for t in 0...100 do
#   t+=1
#   a = []
#   b = []
#   out = []
#   mixkey = [];4.times{v = rand(-16..15);val = "%04b" % [v].pack('L').unpack('L');val = val.rjust(32,"0"); mixkey << val}
#   ciphermix = [];mixkey.each{|item|st1 = [];i = 0;16.times{dat = item.scan(/../);st1.push(dat[i+1] + dat[i]) if i <= 15;i+=2};st2 = []; i = 0; 8.times{st2 << st1 [ i - 3 ]; i+=1};ciphermix.push(st2.join)}
#   dat = (((Time.now.to_i / 86400) * 86400) - 1515616054).to_s(16);dat = dat.rjust(8,"0");regxp = ".";arr = ciphermix[0].scan(/#{regxp}/).zip(ciphermix[1].scan(/#{regxp}/),ciphermix[2].scan(/#{regxp}/),ciphermix[3].scan(/#{regxp}/)).join.scan(/.../).map{|i|i.reverse}.join.to_i(2).to_s(16)[0..-9] + dat
#   dat
#   out << arr.scan(/..../)
#   a = mixkey.map{|i|i[0..8].include?('00000') ? val = [i.to_i(2)].pack('c*').unpack('H*')[0].to_i(16) : val = [i.to_i(2)].pack('c*').unpack('H*')[0].to_i(16) - 16**2}
#   inv = out
#   dat = Time.at(inv.join.downcase[-8..-1].to_i(16) * 86400 / 86400 + 1515616054)
#   cipher = (inv.join.downcase[0..-9] + (inv.join.downcase[-11..-9] * 3)[0..-2]).to_i(16).to_s(2)
#   cipher = "0"*(126 - cipher.to_s.length) + cipher
#   out1 = [];s1 = [];4.times{|n|s1 << cipher.scan(/.../).map{|i|i.reverse}.join.scan(/..../).map{|i|i[n]}.join};out1 = s1.map{|i|i = i + i[-1]}
#   out2 = [];out1.each{|item|v = [];v1 = [];v2 = [];i = -8; 8.times{v << item.scan(/..../)[i + 3];i+=1};v1 << v.join;v1.each{|i|dat = i.scan(/../);i = 0;16.times{v2 << dat[i + 1] + dat[i] if i <= 15;i+=2}};v2.join.length < 32 ? out2 << v2.join + "0" : out2 << v2.join}
#   b = out2.map{|i|i[0..8].include?('00000') ? val = [i.to_i(2)].pack('c*').unpack('H*')[0].to_i(16) : val = [i.to_i(2)].pack('c*').unpack('H*')[0].to_i(16) - 16**2}
#   t-=1 if mixkey != out2
#   print "#{a}...#{b}\n#{cipher} --- cipher\n#{arr} --- arr\n#{out1} --- out1\n#{s1} --- s1\n#{ciphermix} --- ciphermix\n#{mixkey} --- mixkey\n#{out2} --- out2\n\n" if mixkey == out2
# end


# def decrypt(key,data)
#   inv = key.split('-')
#   dat = Time.at(inv.join.downcase[-8..-1].to_i(16) * 86400 / 86400 + 1515616054)
#   cipher = (inv.join.downcase[0..-9] + (inv.join.downcase[-11..-9] * 3)[0..-2]).to_i(16).to_s(2)
#   cipher = "0"*(126 - cipher.to_s.length) + cipher
#   out1 = [];s1 = [];4.times{|n|s1 << cipher.scan(/.../).map{|i|i.reverse}.join.scan(/..../).map{|i|i[n]}.join};out1 = s1.map{|i|i = i + i[-1]}
#   out2 = [];out1.each{|item|v = [];v1 = [];v2 = [];i = -8; 8.times{v << item.scan(/..../)[i + 3];i+=1};v1 << v.join;v1.each{|i|dat = i.scan(/../);i = 0;16.times{v2 << dat[i + 1] + dat[i] if i <= 15;i+=2}};v2.join.length < 32 ? out2 << v2.join + "0" : out2 << v2.join}
#   vardata = out2.map{|i|i[0..8].include?('00000') ? val = [i.to_i(2)].pack('c*').unpack('H*')[0].to_i(16) : val = [i.to_i(2)].pack('c*').unpack('H*')[0].to_i(16) - 16**2}
#   ###
#   decipher = OpenSSL::Cipher::AES.new(128, :ECB)
#   decipher.decrypt
#   key = [];data1 = File.read(data).unpack('L*');vardata.reverse.map{|i| key.push(data1[i.to_i]);data1.delete_at(i.to_i)}
#   puts "#{data1.pack('N*')} --- data1"
#   puts "#{key} --- key"
#   decipher.key = key.reverse.pack('N*')
#   p "#{key.reverse.pack('N*')} -- key"
#   decipher.update(data1.pack('N*')) + decipher.final
# end