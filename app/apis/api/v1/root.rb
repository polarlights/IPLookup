module API
  module V1
    class Root < Grape::API
      version "v1", using: :path

      helpers V1::Helpers

      mount V1::Iplocation

    end
  end
end
