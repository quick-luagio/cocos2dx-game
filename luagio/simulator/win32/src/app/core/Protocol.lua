local Protocol = {}


function Protocol.writeGetUser(askData)
   local byteArray = ByteArray.new()
   byteArray.writeString(askData.userName)
   byteArray.write
end












return Protocol