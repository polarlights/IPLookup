module IPLookup
  class API < Grape::API
   version 'v1'
   format :json
   prefix :api

   desc "Query API For IP"
   params do
     requires :ip, type: String, desc: "IP you want to query"
   end
   get '/' do

   end
  end
end
