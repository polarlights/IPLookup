module API
  module V1
    class Iplocation < Grape::API
     resource :ip do
       desc "hello world"
       get '/' do
         puts "hello world"
       end
     end
    end
  end
end
